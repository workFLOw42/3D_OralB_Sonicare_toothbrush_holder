// =====================================================================
//  body.scad  -  Rechteckiger Korpus (Wanne) mit:
//   - allseitig abgerundeten Kanten/Ecken (R = fillet_r)
//   - geschlossenem Boden; HINTEN offen für die einschiebbare Rückwand
//   - Feder-&-Nut-Schiebehaltung der Einsätze: seitliche Lippen an der
//     Fach-Oberkante (Einsatz von hinten einschieben, Frontwand = Anschlag)
//   - zwei hintere Eckpfosten (nach außen verdickt) mit vertikaler Nut +
//     Boden-Nut für die Rückwand
//   - 4 Füßen; Voronoi-Relief (eingerückt) auf Front + 2 Seiten
// =====================================================================
include <params.scad>
include <voronoi_data.scad>
use <voronoi.scad>

// Vollkörper mit allseitig abgerundeten Kanten (Minkowski mit Kugel)
module rounded_block(w, d, h, r) {
    minkowski() {
        translate([r, r, r]) cube([w - 2*r, d - 2*r, h - 2*r]);
        sphere(r = r, $fn = 24);
    }
}

// Fach-Aushöhlung je Fach als 3-Band-Profil (hinten offen):
//   Band 1: unteres Fach (Ladestation/Auflage), schmaler -> Ledge
//   Band 2: Einsatzkörper, volle Fachbreite
//   Band 3: "Mund" oben, schmaler -> stehenbleibende Lippe übergreift den Einsatz
module bay_cutouts() {
    yb = wall_t;                 // Front-Innenkante (Frontwand bleibt Anschlag)
    yd = outer_d + 1 - yb;       // nach hinten durchgehend offen
    for (i = [0 : n_bays - 1]) {
        fn = bays[i][0]; mk = bays[i][1];
        x0 = wall_t + i * (bay_inner_w + divider_t);
        pf = (fn == "charge") ? (body_height - charger_h(fn, mk)) : floor_t;
        // Band 1: unteres Fach (schmaler) -> umlaufende Auflage (Ledge)
        translate([x0 + ledge_w, yb, pf])
            cube([bay_inner_w - 2*ledge_w, yd, body_height]);
        // Band 2: Einsatzkörper (volle Breite)
        translate([x0, yb, body_height - insert_h])
            cube([bay_inner_w, yd, insert_h - rail_thick]);
        // Band 3: Mund (schmaler) -> Lippe bleibt an den Fachkanten stehen
        translate([x0 + rail_overhang, yb, body_height - rail_thick])
            cube([bay_inner_w - 2*rail_overhang, yd, rail_thick + 1]);
    }
}

// Rückwand-Aufnahme (Subtraktion): Plattenraum (volle Innenbreite, hinten/oben
// offen) + zwei vertikale Feder-Nuten BÜNDIG in den dicken Seitenwänden
// (kein Außenpfosten) + quer laufende Boden-Nut. Die Wand vor der Nut
// (y < rear_wall_y0) bleibt stehen und fängt die Feder in Y.
module rear_cut() {
    // Plattenraum
    translate([wall_t - rear_clear, rear_wall_y0 - rear_clear, floor_t])
        cube([inner_w + 2*rear_clear, rear_wall_t + rear_clear + 1, body_height + 1]);
    // seitliche Feder-Nuten (links/rechts): HINTEN GESCHLOSSEN (Wand-Skin
    // rear_back_skin bleibt stehen) -> Feder in Y gefangen, Rückwand sitzt fest.
    xg0 = wall_t - rear_tongue_w - rear_clear;
    gd  = rear_wall_t + rear_clear - rear_back_skin;   // Nuttiefe in Y (zu)
    for (sx = [0, 1]) {
        gx = (sx == 0) ? xg0 : (outer_w - wall_t);
        translate([gx, rear_wall_y0 - rear_clear, floor_t - floor_groove_d])
            cube([rear_tongue_w + rear_clear, gd, body_height + 1]);
    }
    // Boden-Nut quer (Plattenunterkante), ebenfalls hinten geschlossen
    translate([wall_t - rear_tongue_w, rear_wall_y0, floor_t - floor_groove_d])
        cube([inner_w + 2*rear_tongue_w, rear_wall_t - rear_back_skin,
              floor_groove_d + 0.01]);
}

module feet() {
    insets = foot_inset + foot_r;     // Mittelpunkt vom Rand
    for (px = [insets, outer_w - insets],
         py = [insets, outer_d - insets])
        translate([px, py, -foot_h])
            cylinder(h = foot_h + 2, r = foot_r, $fn = 36);
}

// Nut-Anschlag HINTEN: kleiner eckiger Block hinter jeder Feder-Nut, der die
// (durch die Eckrundung weggefräste) Rückwand des Nut-Kanals wiederherstellt
// -> Rückwand-Feder ist in Y gefangen. Wird NACH der Differenz vereinigt, damit
// er voll massiv bleibt.
module rear_stops() {
    xg0 = wall_t - rear_tongue_w - rear_clear;
    for (sx = [0, 1]) {
        gx = (sx == 0) ? xg0 : (outer_w - wall_t);
        translate([gx, outer_d - rear_back_skin, floor_t - floor_groove_d])
            cube([rear_tongue_w + rear_clear, rear_back_skin,
                  body_height - (floor_t - floor_groove_d)]);
    }
}

// Rundungs-Hülle für den Korpus: rundet ALLE Oberkanten sauber mit R5 (auch die
// eckig gefräste Nut-Oberkante hinten). XY um Relief-Aufmaß größer + nach unten weit
// offen -> Relief und Füße werden NICHT beschnitten.
module _body_round_env() {
    e = relief_h + 0.5;                       // XY-Aufmaß (Relief nicht clippen)
    minkowski() {
        translate([fillet_r - e, fillet_r - e, fillet_r - foot_h - 1])
            cube([outer_w - 2*fillet_r + 2*e, outer_d - 2*fillet_r + 2*e,
                  body_height - 2*fillet_r + foot_h + 1]);
        sphere(r = fillet_r, $fn = 24);
    }
}

module body() {
    intersection() {
        union() {
            difference() {
                union() {
                    rounded_block(outer_w, outer_d, body_height, fillet_r);
                    feet();
                    // Voronoi-Relief (eingerückt um fillet_r) auf Front + 2 Seiten
                    // (Rückseite trägt die separate Rückwand -> dort eigenes Relief)
                    relief_front(outer_w, body_height, voro_face_long,  voro_strut, relief_h, fillet_r);
                    relief_left (outer_d, body_height, voro_face_short, voro_strut, relief_h, fillet_r);
                    relief_right(outer_w, outer_d, body_height, voro_face_short, voro_strut, relief_h, fillet_r);
                }
                bay_cutouts();
                rear_cut();
            }
            rear_stops();
        }
        _body_round_env();
    }
}

body();
