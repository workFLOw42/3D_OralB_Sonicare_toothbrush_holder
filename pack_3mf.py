"""Packt Korpus + 4 Gitter in EIN 3MF, flach auf einer Platte angeordnet
(passt auf den Bambu X2D-Tisch 256x256). In Bambu Studio direkt öffenbar.
"""
import os
import time
import trimesh
import numpy as np

D = os.path.dirname(os.path.abspath(__file__))
GAP = 6.0

def load(name):
    # Retry: frisch von OpenSCAD geschriebene STL kann kurz noch nicht lesbar sein
    # (Flush/AV-Scan) -> trimesh.load liefert dann None.
    for _ in range(8):
        m = trimesh.load(rf"{D}\{name}", force="mesh")
        if m is not None and len(m.vertices) > 0:
            return m
        time.sleep(0.3)
    raise RuntimeError(f"konnte {name} nicht laden: {rf'{D}\{name}'}")

def at(mesh, x, y):
    m = mesh.copy()
    m.apply_translation(-m.bounds[0])              # min-Ecke -> Ursprung
    m.apply_translation([x, y, 0])
    return m

scene = trimesh.Scene()
body = load("body.stl")
scene.add_geometry(at(body, 0, 0), geom_name="Korpus_Voronoi")

bw = body.extents[0]
y_row = body.extents[1] + GAP
labels = ["Gitter1_OralB_Staender", "Gitter2_OralB_Laden",
          "Gitter3_Sonicare_Laden", "Gitter4_Sonicare_Staender"]
x = 0.0
for i, lab in enumerate(labels):
    g = load(f"grid{i}.stl")
    scene.add_geometry(at(g, x, y_row), geom_name=lab)
    x += g.extents[0] + GAP

# separate Rückwand flach mit auf die Platte (zweite Reihe)
rw = load("rearwall.stl")
y_row2 = y_row + max(load(f"grid{i}.stl").extents[1] for i in range(4)) + GAP
scene.add_geometry(at(rw, 0, y_row2), geom_name="Rueckwand_Voronoi")

# 4 identische Steck-Füße (Zapfen oben, wie gedruckt) in eigener Reihe
foot = load("foot.stl")
y_row3 = y_row2 + rw.extents[1] + GAP
fx = 0.0
for i in range(4):
    scene.add_geometry(at(foot, fx, y_row3), geom_name=f"Fuss_{i + 1}")
    fx += foot.extents[0] + GAP

out = rf"{D}\Zahnbuersten_Voronoi_4er.3mf"
scene.export(out)
bb = scene.bounds
print("Platte Bauraum:", (bb[1] - bb[0])[:2].round(1), "mm (Tisch 256x256)")
print("geschrieben:", out)
