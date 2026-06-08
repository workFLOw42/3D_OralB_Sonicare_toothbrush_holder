// =====================================================================
//  voronoi.scad  -  Voronoi-Netz (2D) + Relief-Platzierung auf Flächen
// =====================================================================

// 2D-Netz: jedes Segment wird zu einer "Kapsel" (hull zweier Kreise).
module voro_web_2d(segs, strut) {
    r = strut / 2;
    union()
        for (s = segs)
            hull() {
                translate([s[0], s[1]]) circle(r = r, $fn = 16);
                translate([s[2], s[3]]) circle(r = r, $fn = 16);
            }
}

// Relief-Scheibe: Netz auf Rechteck w x h geclippt, Dicke "thick" in +Z.
// Taucht "ov" mm in den Körper ein (-Z), damit es sicher verschmilzt.
module voro_slab(w, h, segs, strut, thick, ov = 0.8) {
    translate([0, 0, -ov])
        linear_extrude(height = thick + ov)
            intersection() {
                square([w, h]);
                voro_web_2d(segs, strut);
            }
}

// --- Platzierung auf den 4 Außenflächen eines Korpus (x:0..W, y:0..D, z:0..H)
//     Relief ragt nach außen (erhaben), um Rand-Margin m eingerückt
//     (sitzt so auf den flachen Bändern, nicht in den abgerundeten Kanten).
//     segs sind bereits für (Seite-2m) x (H-2m) erzeugt.
module relief_front(W, H, segs, strut, thick, m)           // -Y bei y=0
    translate([m, 0, m]) rotate([90, 0, 0])
        voro_slab(W - 2*m, H - 2*m, segs, strut, thick);

module relief_back(W, D, H, segs, strut, thick, m)         // +Y bei y=D
    translate([W - m, D, m]) rotate([90, 0, 180])
        voro_slab(W - 2*m, H - 2*m, segs, strut, thick);

module relief_left(D, H, segs, strut, thick, m)            // -X bei x=0
    translate([0, D - m, m]) rotate([90, 0, -90])
        voro_slab(D - 2*m, H - 2*m, segs, strut, thick);

module relief_right(W, D, H, segs, strut, thick, m)        // +X bei x=W
    translate([W, m, m]) rotate([90, 0, 90])
        voro_slab(D - 2*m, H - 2*m, segs, strut, thick);
