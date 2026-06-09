// =====================================================================
//  rear_wall.scad  -  separate Rückwand, von oben senkrecht eingeschoben
//   - Platte (inner_w x body_height x rear_wall_t)
//   - seitliche Federn links/rechts (volle Plattentiefe, mit Einführfase) ->
//     gleiten in die senkrechten Nuten der massiven Eckpfosten; der volle
//     Pfosten HINTER der Nut fängt die Feder in Y (robust, kein dünner Steg).
//   - Unterkante in der Boden-Nut gelagert
//   - Voronoi-Relief außen (auf der Plattenrückseite)
//   - je Fach ein nach UNTEN offener Kabel-Schlitz (Stecker passt durch)
//  Render:  openscad -o rearwall.stl rear_wall.scad
// =====================================================================
include <params.scad>
include <voronoi_data.scad>
use <voronoi.scad>

x0r = wall_t;  x1r = outer_w - wall_t;          // Plattenränder (X)
z0r = floor_t - floor_groove_d;                 // Unterkante (in Boden-Nut)
phr = body_height - z0r;
y_back = rear_wall_y0 + rear_wall_t;            // Plattenrückseite (Relief-Ebene)

// Voronoi-Relief auf der Außenseite (gleiches Band wie Korpus-Front/Rück).
//  Platte sitzt bei y in [rear_wall_y0, y_back]; Relief erhaben auf y_back.
module rear_relief() {
    m = fillet_r;
    intersection() {
        translate([outer_w - m, y_back, m]) rotate([90, 0, 180])
            voro_slab(outer_w - 2*m, body_height - 2*m, voro_face_long, voro_strut, relief_h);
        translate([wall_t, rear_wall_y0 - 1, 0])           // auf Plattengröße clippen
            cube([inner_w, rear_wall_t + relief_h + 2, body_height]);
    }
}

// seitliche Feder mit Einführfase unten (sx=0 links, 1 rechts).
// Feder = Platte seitlich verlängert über die VOLLE Plattentiefe (Y) -> teilt sich
// eine durchgehende Fläche mit der Platte (sauber verschmolzen) und greift in die
// Pfosten-Nut. In Y zwischen Nut-Vorderwand und massivem Pfosten dahinter gefangen.
module rear_tongue(sx) {
    xin  = (sx == 0) ? x0r : x1r;
    xout = (sx == 0) ? x0r - rear_tongue_w : x1r + rear_tongue_w;
    lo = min(xin, xout); hi = max(xin, xout);
    blo = (sx == 0) ? lo + rear_lead : lo;             // Fase: Boden outboard zurück
    bhi = (sx == 0) ? hi : hi - rear_lead;
    td  = rear_tongue_d;                               // Feder-Tiefe (Y) vorn -> Pfosten-Nut
    hull() {
        translate([lo, rear_wall_y0, z0r + rear_lead])
            cube([rear_tongue_w, td, phr - rear_lead]);
        translate([blo, rear_wall_y0, z0r]) cube([bhi - blo, td, 0.1]);
    }
}

// nach unten offener Kabel-Schlitz (gerundete Oberkante)
module cable_slot(cx) {
    r = cable_hole_w / 2;
    yb = rear_wall_y0 - 1; yl = rear_wall_t + relief_h + 2;
    zt = floor_t + cable_hole_h;                       // Oberkante
    translate([cx, yb, zt - r]) rotate([-90, 0, 0]) cylinder(r = r, h = yl, $fn = 28);
    translate([cx - r, yb, z0r - 5]) cube([cable_hole_w, yl, (zt - r) - (z0r - 5)]);
}

// Rundungs-Hülle = Gehäuse-Außenform (R5), in +Y um das Relief verlängert.
// outer_d (= Pfosten-Rückseite) deckt Platte + Feder + Relief voll ab -> rundet die
// oberen Kanten der Platte, ohne die Feder zu beschneiden.
module _round_env() {
    minkowski() {
        translate([fillet_r, fillet_r, fillet_r])
            cube([outer_w - 2*fillet_r, outer_d + relief_h - 2*fillet_r,
                  body_height - 2*fillet_r]);
        sphere(r = fillet_r, $fn = 24);
    }
}

module rear_wall() {
    intersection() {
        difference() {
            union() {
                translate([x0r, rear_wall_y0, z0r]) cube([inner_w, rear_wall_t, phr]);
                rear_tongue(0); rear_tongue(1);
                rear_relief();
            }
            for (i = [0 : n_bays - 1])
                cable_slot(wall_t + i*(bay_inner_w + divider_t) + bay_inner_w/2);
        }
        _round_env();
    }
}

rear_wall();