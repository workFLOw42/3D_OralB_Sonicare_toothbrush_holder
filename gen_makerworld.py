"""Baut die MakerWorld-Einzeldatei zahnbuersten_voronoi_makerworld.scad aus den
Quell-.scad. Konkateniert params + voronoi + voronoi_data + body + grid + rear_wall
+ foot, entfernt include/use-Zeilen und die Top-Level-Render-Aufrufe und hängt
Customizer-Header + Druckplatte + Teil-Dispatcher an.
Aufruf:  python gen_makerworld.py   (nach gen_voronoi.py / build)."""
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "zahnbuersten_voronoi_makerworld.scad")


def read(name):
    return open(os.path.join(HERE, name), encoding="utf-8").read()


def strip_includes(t):
    return re.sub(r'^[ \t]*(include|use)[ \t]*<[^>]+>[ \t]*\n', '', t, flags=re.M)


def strip_lines(t, patterns):
    out = []
    for ln in t.splitlines():
        if any(re.fullmatch(p, ln.strip()) for p in patterns):
            continue
        out.append(ln)
    return "\n".join(out)


HEADER = """// =====================================================================
//  Elektr. Zahnbuerstenhalter (Oral-B + Sonicare), frei konfigurierbar
//  EIN-DATEI / self-contained fuer MakerWorld (Parametric Model Maker).
//  Steck-System v2: flaches Deko-Voronoi, geschlossene Einschuebe (+ Ablage),
//  steckbare Fuesse. AUTO-GENERIERT von gen_makerworld.py - nicht von Hand editieren.
// =====================================================================

/* [Teil-Auswahl] */
// Was erzeugen? "platte" = alle Teile druckfertig auf einer X2D-Platte.
part = "platte"; // [platte:Alle Teile auf X2D-Platte, montage:Montage-Vorschau, korpus:Korpus, gitter1:Einsatz Fach 1, gitter2:Einsatz Fach 2, gitter3:Einsatz Fach 3, gitter4:Einsatz Fach 4, rueckwand:Rueckwand, fuss:Steck-Fuss, ablage:Ablage (geschlossen)]

/* [Hinweis] */
// Das Voronoi-Flaechenrelief ist fuer 4 Faecher vorberechnet; bei weniger Faechern
// wird es vorne nur beschnitten (rein optisch). Die Einschub-Muster sind unabhaengig.
"""

DISPATCH = """
// ============================ Druckplatte + Teil-Auswahl ============================
module _platte() {
    GAP = 8;
    gw = bay_inner_w - 2*clearance;        // Einschubbreite
    gd = insert_depth - 2*clearance;       // Einschubtiefe
    row2 = outer_d + GAP;                  // Reihe Einschuebe
    row3 = row2 + gd + GAP;                // Reihe Rueckwand
    body();
    for (i = [0 : n_bays - 1])
        translate([i*(gw + GAP), row2, 0]) grid_insert(bays[i][0], bays[i][1]);
    // Rueckwand flach gekippt (Relief nach oben)
    translate([0, row3 + body_height, -rear_wall_y0]) rotate([90, 0, 0]) rear_wall();
    // 4 Steck-Fuesse (Zapfen oben, wie gedruckt) in eigener Reihe
    for (i = [0:3])
        translate([i*(2*foot_r + GAP) + foot_r, row3 + body_height + GAP + foot_r, 0])
            corner_foot();
}

module _montage() {
    body();
    corner_feet();
    for (i = [0 : n_bays - 1])
        translate([wall_t + i*(bay_inner_w + divider_t) + clearance,
                   wall_t + clearance, body_height - insert_h])
            grid_insert(bays[i][0], bays[i][1]);
    rear_wall();
}

if      (part == "platte")                 _platte();
else if (part == "korpus")                 body();
else if (part == "gitter1" && n_bays >= 1) grid_insert(bays[0][0], bays[0][1]);
else if (part == "gitter2" && n_bays >= 2) grid_insert(bays[1][0], bays[1][1]);
else if (part == "gitter3" && n_bays >= 3) grid_insert(bays[2][0], bays[2][1]);
else if (part == "gitter4" && n_bays >= 4) grid_insert(bays[3][0], bays[3][1]);
else if (part == "rueckwand")              rear_wall();
else if (part == "fuss")                   corner_foot();
else if (part == "ablage")                 grid_insert("tray", "-");
else                                       _montage();
"""


def section(title, body):
    return f"\n// ============================ {title} ============================\n" + body.strip("\n") + "\n"


def main():
    params = strip_includes(read("params.scad"))
    voronoi = strip_includes(read("voronoi.scad"))
    vdata = read("voronoi_data.scad")
    body = strip_lines(strip_includes(read("body.scad")), [r"body\(\);"])
    grid = strip_lines(strip_includes(read("grid.scad")),
                       [r"bay_index\s*=\s*\d+;.*", r"fn\s*=\s*bays\[bay_index\]\[0\];",
                        r"mk\s*=\s*bays\[bay_index\]\[1\];", r"grid_insert\(fn, mk\);"])
    rear = strip_lines(strip_includes(read("rear_wall.scad")), [r"rear_wall\(\);"])
    foot = strip_lines(strip_includes(read("foot.scad")), [r"corner_foot\(\);"])

    parts = [
        HEADER,
        section("params.scad", params),
        section("voronoi.scad", voronoi),
        section("voronoi_data.scad", vdata),
        section("body.scad", body),
        section("grid.scad", grid),
        section("rear_wall.scad", rear),
        section("foot.scad", foot),
        DISPATCH,
    ]
    open(OUT, "w", encoding="utf-8").write("\n".join(parts))
    print("geschrieben:", OUT)


if __name__ == "__main__":
    main()
