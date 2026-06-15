// =====================================================================
//  foot.scad  -  separater Steck-Fuß (Kabelbox-Stil)
//  Zylinder Ø2*foot_r × foot_h mit Zapfen Ø peg_d × peg_h nach OBEN; wird
//  von unten in das Boden-Sackloch gesteckt. Zapfen zeigt nach oben ->
//  stützenfrei druckbar (Fußkörper liegt beim Druck auf der Platte).
//  Render einzeln:  openscad -o foot.stl foot.scad
// =====================================================================
include <params.scad>

// Kanonischer Fuß am Ursprung: Körper z=0..foot_h, Zapfen z=foot_h..+peg_h.
module corner_foot() {
    cylinder(d = 2*foot_r, h = foot_h, $fn = 48);
    // Zapfen mit kleiner Einführfase an der Spitze
    translate([0, 0, foot_h - 0.01]) {
        cylinder(d = peg_d, h = peg_h - peg_chamfer + 0.01, $fn = 32);
        translate([0, 0, peg_h - peg_chamfer])
            cylinder(d1 = peg_d, d2 = peg_d - 2*peg_chamfer, h = peg_chamfer, $fn = 32);
    }
}

// 4 Füße an den Eckpositionen, Körper unter dem Boden (z = -foot_h).
module corner_feet()
    for (p = foot_pts())
        translate([p[0], p[1], -foot_h]) corner_foot();

corner_foot();
