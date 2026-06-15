// =====================================================================
//  assembly.scad  -  Vorschau: Korpus + 4 Einsätze (nur zur Ansicht)
// =====================================================================
include <params.scad>
include <voronoi_data.scad>
use <voronoi.scad>
use <body.scad>
use <grid.scad>
use <rear_wall.scad>
use <foot.scad>

color([0.20, 0.45, 0.75]) body();
color([0.95, 0.80, 0.30]) corner_feet();   // 4 steckbare Füße (unter dem Boden)

// Einsätze an Endposition (von hinten eingeschoben, vorne am Anschlag)
for (i = [0 : n_bays - 1]) {
    x0   = wall_t + i * (bay_inner_w + divider_t);
    fn   = bays[i][0];
    mk   = bays[i][1];
    col  = (fn == "charge") ? [0.90, 0.90, 0.93] : [0.95, 0.80, 0.30];
    color(col)
        translate([x0 + clearance, wall_t + clearance, body_height - insert_h])
            grid_insert(fn, mk);
}

// separate Rückwand (eingeschoben)
color([0.30, 0.55, 0.80]) rear_wall();
