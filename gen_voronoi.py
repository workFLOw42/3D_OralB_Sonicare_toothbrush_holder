"""Erzeugt Voronoi-Kantensegmente und schreibt voronoi_data.scad.

- Liest die benötigten Maße aus params.scad (einzige Wahrheitsquelle).
- Streut deterministisch (Seed) ein jitter-Gitter aus Saatpunkten über ein
  um eine Zelle vergrößertes Rechteck (-> randnahe Zellen sind geschlossen).
- scipy.spatial.Voronoi -> endliche Ridge-Segmente -> auf das Rechteck geclippt.
- Ausgabe je benötigtem Rechteck: Liste [x1,y1,x2,y2].
"""
import re
import numpy as np
from scipy.spatial import Voronoi
import os

# Pfade relativ zum Skript -> funktioniert aus jedem Klon.
_HERE = os.path.dirname(os.path.abspath(__file__))

PARAMS = os.path.join(_HERE, "params.scad")
OUT = os.path.join(_HERE, "voronoi_data.scad")


def read_params(path):
    txt = open(path, encoding="utf-8").read()
    p = {}
    for m in re.finditer(r'^\s*(\w+)\s*=\s*([-\d.]+)\s*;', txt, re.M):
        p[m.group(1)] = float(m.group(2))
    # abgeleitet (identisch zu params.scad)
    p["inner_w"] = p["n_bays"] * p["bay_inner_w"] + (p["n_bays"] - 1) * p["divider_t"]
    p["outer_w"] = p["inner_w"] + 2 * p["wall_t"]
    p["outer_d"] = p["wall_t"] + p["body_depth"] + p["rear_wall_t"]
    p["rear_wall_y0"] = p["outer_d"] - p["rear_wall_t"]
    p["insert_depth"] = p["rear_wall_y0"] - p["rear_clear"] - p["wall_t"]
    return p


def liang_barsky(x0, y0, x1, y1, w, h):
    """Clip Segment auf Rechteck [0,w]x[0,h]; None falls außerhalb."""
    dx, dy = x1 - x0, y1 - y0
    p = [-dx, dx, -dy, dy]
    q = [x0 - 0, w - x0, y0 - 0, h - y0]
    u0, u1 = 0.0, 1.0
    for pi, qi in zip(p, q):
        if pi == 0:
            if qi < 0:
                return None
        else:
            t = qi / pi
            if pi < 0:
                u0 = max(u0, t)
            else:
                u1 = min(u1, t)
    if u0 > u1:
        return None
    return (x0 + u0 * dx, y0 + u0 * dy, x0 + u1 * dx, y0 + u1 * dy)


def voro_segments(w, h, cell, seed):
    rng = np.random.default_rng(seed)
    m = cell  # Randüberstand
    nx = max(2, int(round((w + 2 * m) / cell)))
    ny = max(2, int(round((h + 2 * m) / cell)))
    xs = np.linspace(-m, w + m, nx)
    ys = np.linspace(-m, h + m, ny)
    gx, gy = np.meshgrid(xs, ys)
    pts = np.column_stack([gx.ravel(), gy.ravel()]).astype(float)
    jit = (rng.random(pts.shape) - 0.5) * cell * 0.8
    pts += jit
    vor = Voronoi(pts)
    segs = []
    for (a, b) in vor.ridge_vertices:
        if a < 0 or b < 0:
            continue
        x0, y0 = vor.vertices[a]
        x1, y1 = vor.vertices[b]
        c = liang_barsky(x0, y0, x1, y1, w, h)
        if c and (abs(c[0] - c[2]) > 1e-6 or abs(c[1] - c[3]) > 1e-6):
            segs.append(c)
    return segs


def fmt(segs):
    return "[\n" + ",\n".join(
        f"  [{s[0]:.3f},{s[1]:.3f},{s[2]:.3f},{s[3]:.3f}]" for s in segs) + "\n]"


def main():
    p = read_params(PARAMS)
    seed = int(p["voro_seed"])
    cell_i = p["voro_cell"]; cell_f = p.get("voro_cell_face", cell_i)
    m = p.get("fillet_r", 0.0)   # Relief um Fillet-Radius einrücken (flache Bänder)
    # Becher-Außenwände (Fläche - 2*cup_round, da Relief um cup_round eingerückt)
    cw = p["bay_inner_w"] - 2 * p["clearance"]      # Becher-Außenbreite (X)
    cd = p["insert_depth"] - 2 * p["clearance"]     # Becher-Außentiefe (Y)
    rr = p.get("cup_round", 5.0); ch = p.get("cup_h", 80.0)
    jobs = {
        "voro_face_long":  (p["outer_w"] - 2 * m, p["body_height"] - 2 * m, seed,     cell_f),
        "voro_face_short": (p["outer_d"] - 2 * m, p["body_height"] - 2 * m, seed + 1, cell_f),
        "voro_insert":     (p["bay_inner_w"], p["body_depth"], seed + 2,              cell_i),
        "voro_cup_w":      (cw - 2 * rr, ch - 2 * rr, seed + 3,                       cell_f),
        "voro_cup_d":      (cd - 2 * rr, ch - 2 * rr, seed + 4,                       cell_f),
    }
    lines = ["// AUTO-GENERIERT von gen_voronoi.py - nicht von Hand editieren.",
             f"// cell_face={cell_f} cell_insert={cell_i} seed={seed}", ""]
    for name, (w, h, sd, cell) in jobs.items():
        segs = voro_segments(w, h, cell, sd)
        lines.append(f"// {name}: Rechteck {w:.1f} x {h:.1f} mm, {len(segs)} Segmente")
        lines.append(f"{name} = {fmt(segs)};")
        lines.append("")
        print(f"{name}: {w:.1f} x {h:.1f} mm -> {len(segs)} Segmente")
    lines.append(f"voro_dims = [[{p['outer_w']:.2f},{p['body_height']:.2f}],"
                 f"[{p['outer_d']:.2f},{p['body_height']:.2f}],"
                 f"[{p['bay_inner_w']:.2f},{p['body_depth']:.2f}]];")
    open(OUT, "w", encoding="utf-8").write("\n".join(lines))
    print("geschrieben:", OUT)


if __name__ == "__main__":
    main()
