// =====================================================================
//  body.scad  -  Rechteckiger Korpus (Wanne) mit:
//   - allseitig abgerundeten Kanten/Ecken (R = fillet_r)
//   - geschlossenem Boden; HINTEN offen für die einschiebbare Rückwand
//   - Feder-&-Nut-Schiebehaltung der Einsätze: seitliche Lippen an der
//     Fach-Oberkante (Einsatz von hinten einschieben, Frontwand = Anschlag)
//   - zwei MASSIVE hintere Eckpfosten (Kabelbox-Stil, rear_wall_t tief). Die
//     senkrechte Rückwand füllt sie bündig; ihre Feder greift VORN in die Nut, DAHINTER der volle
//     Pfosten stehen (~5,7 mm) -> Feder in Y gefangen, kein dünner Steg/Anschlag,
//     der beim Stützen-Entfernen bricht.
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

// Fach-Aushöhlung je Fach als 3-Band-Profil (endet an der Rückwand-Vorderkante;
// der Bereich dahinter wird von rear_cut geöffnet):
//   Band 1: unteres Fach (Ladestation/Auflage), schmaler -> Ledge
//   Band 2: Einsatzkörper, volle Fachbreite
//   Band 3: "Mund" oben, schmaler -> stehenbleibende Lippe übergreift den Einsatz
module bay_cutouts() {
    yb = wall_t;                 // Front-Innenkante (Frontwand bleibt Anschlag)
    yd = rear_wall_y0 - yb;      // Hohlraum endet an der Rückwand-Vorderkante
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

// Rückwand-Aufnahme (Subtraktion):
//   - Plattenraum: volle Innenbreite bis zur Rückseite -> die rear_wall_t tiefe
//     Rückwand füllt ihn bündig; Trennwände enden vor der Rückwand (keine Stummel).
//   - zwei senkrechte Feder-Nuten VORN in den MASSIVEN Eckpfosten (nur rear_tongue_d tief).
//     Hinter der Nut bleibt der volle Pfosten stehen -> Feder in Y gefangen, robust.
//   - quer laufende Boden-Nut für die Plattenunterkante.
module rear_cut() {
    // Plattenraum (bis zur Rückseite durchgehend -> öffnet die Pfosten-Lücke)
    translate([wall_t - rear_clear, rear_wall_y0 - rear_clear, floor_t])
        cube([inner_w + 2*rear_clear,
              outer_d - rear_wall_y0 + rear_clear + 1, body_height + 1]);
    // seitliche Feder-Nuten (links/rechts) VORN im Pfosten (nur rear_tongue_d tief).
    xg0 = wall_t - rear_tongue_w - rear_clear;
    for (sx = [0, 1]) {
        gx = (sx == 0) ? xg0 : (outer_w - wall_t);
        translate([gx, rear_wall_y0 - rear_clear, floor_t - floor_groove_d])
            cube([rear_tongue_w + rear_clear, rear_tongue_d + 2*rear_clear,
                  body_height + 1]);
    }
    // Boden-Nut quer (Plattenunterkante)
    translate([wall_t - rear_tongue_w, rear_wall_y0, floor_t - floor_groove_d])
        cube([inner_w + 2*rear_tongue_w, rear_wall_t, floor_groove_d + 0.01]);
}

module feet() {
    insets = foot_inset + foot_r;     // Mittelpunkt vom Rand
    for (px = [insets, outer_w - insets],
         py = [insets, outer_d - insets])
        translate([px, py, -foot_h])
            cylinder(h = foot_h + 2, r = foot_r, $fn = 36);
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
        _body_round_env();
    }
}

body();