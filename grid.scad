// =====================================================================
//  grid.scad  -  Einsteckgitter im Voronoi-Stil (ein Fach)
//  Aufruf:  openscad -D bay_index=0 -o grid0.stl grid.scad
//  stand : Voronoi-Panel + zentraler Zapfen (Bürste aufstecken)
//          orb Ø10 x 14 | son Ø7 x 10
//  charge: Voronoi-Panel + Öffnung  orb: Ø42 rund | son: D-Kontur 51x63
// =====================================================================
include <params.scad>
include <voronoi_data.scad>
use <voronoi.scad>

bay_index = 0;   // per -D überschreiben

// D-Kontur der Sonicare-Ladestation: BOGEN nach VORNE (-Y), GERADE nach
// HINTEN (+Y) — passend zur realen Station (gerade Rückseite zur Rückwand).
// y=0 des Einsatzes liegt vorne (an der Frontwand), +Y zeigt nach hinten.
module dshape(w, L) {
    hull() {
        translate([0, -(L/2 - w/2)]) circle(d = w);   // Bogen vorne
        translate([-w/2, L/2 - 1]) square([w, 1]);     // gerade Seite hinten
    }
}

// 2D-Lade-Öffnung, zentriert. grow = umlaufendes Spiel.
//   Oral-B: Ellipse 42x55 | Sonicare: D-Kontur 51x63
module charge_open_2d(mk, grow = 0) {
    if (mk == "son")
        dshape(son_charger_x + 2*grow, son_charger_y + 2*grow);
    else
        resize([orb_charger_x + 2*grow, orb_charger_y + 2*grow]) circle(d = 100);
}

// Lade-Öffnung als 3D-Schnittkörper.
//   Sonicare: gerader, senkrechter Durchbruch.
//   Oral-B:   weitet sich zur UNTERSEITE hin im 45°-Winkel auf (oben snug wie
//             bisher, unten Trichter) -> Ladegerät passt von unten leichter rein.
module charge_cut(mk, grow) {
    if (mk == "orb") {
        flare = insert_h;   // 45°: horizontale Aufweitung == Höhe
        hull() {
            // oben: unveränderte (snug) Öffnung, ragt minimal über die Oberkante
            translate([0, 0, insert_h - 0.01]) linear_extrude(0.02)
                charge_open_2d(mk, grow);
            // unten: um flare aufgeweitet, ragt minimal unter die Unterkante
            translate([0, 0, -0.1]) linear_extrude(0.1)
                offset(flare) charge_open_2d(mk, grow);
        }
    } else {
        translate([0, 0, -0.1]) linear_extrude(insert_h + 0.2) charge_open_2d(mk, grow);
    }
}
// zentrierte Ellipse als 2D
module ellipse(dx, dy) { resize([dx, dy]) circle(d = max(dx, dy), $fn = 56); }

// Oral-B: ovaler, sich verjüngender Zapfen + ovaler Sockel
module peg_orb() {
    b = orb_peg_base; t = orb_peg_tip;
    ellipse_h = orb_peg_h;
    // Sockel (oval, Einsatzhöhe)
    linear_extrude(insert_h) ellipse(b[0] + 2*peg_collar, b[1] + 2*peg_collar);
    // Schaft: von b -> t verjüngt
    translate([0, 0, insert_h])
        linear_extrude(height = ellipse_h, scale = [t[0]/b[0], t[1]/b[1]])
            ellipse(b[0], b[1]);
}

// Sonicare: runder Zapfen Ø7 + runder Sockel, kleine Spitzenfase
module peg_son() {
    pd = son_peg_d; ph = son_peg_h;
    cylinder(d = pd + 2*peg_collar, h = insert_h);
    cylinder(d = pd, h = insert_h + ph - peg_chamfer);
    translate([0, 0, insert_h + ph - peg_chamfer])
        cylinder(d1 = pd, d2 = pd - 2*peg_chamfer, h = peg_chamfer);
}

module grid_panel(w, d, segs) {
    linear_extrude(height = insert_h)
        union() {
            difference() { square([w, d]); offset(-1.8) square([w, d]); }   // Rahmen
            intersection() { square([w, d]); voro_web_2d(segs, voro_strut); }
        }
}

// Einsatz-Hüllprofil (T-Querschnitt): volle Breite unten = Feder, die unter
// die Fach-Lippe greift; schmaler oben (um rail_overhang je Seite), ragt durch
// den "Mund" und schließt bündig ab. rail_clear = vertikales Spiel unter Lippe.
module insert_envelope(w, d) {
    fh = insert_h - rail_thick - rail_clear;   // volle Breite bis hier
    union() {
        cube([w, d, fh]);
        translate([rail_overhang, 0, fh])
            cube([w - 2*rail_overhang, d, insert_h - fh + 0.01]);
    }
}

module grid_insert(fn, mk) {
    w = bay_inner_w  - 2 * clearance;
    d = insert_depth - 2 * clearance;          // lässt hinten Platz für die Rückwand
    cx = w / 2; cy = d / 2;
    if (fn == "stand") {
        union() {
            intersection() { grid_panel(w, d, voro_insert); insert_envelope(w, d); }
            translate([cx, cy, 0])
                if (mk == "orb") peg_orb(); else peg_son();
        }
    } else {  // charge
        grow = son_charger_fit;
        difference() {
            intersection() {
                insert_envelope(w, d);                 // T-Profil = Schiebeführung
                union() {
                    grid_panel(w, d, voro_insert);
                    translate([cx, cy, 0])
                        linear_extrude(insert_h) offset(collar_t) charge_open_2d(mk, grow);
                }
            }
            translate([cx, cy, 0])
                charge_cut(mk, grow);
        }
    }
}

fn = bays[bay_index][0];
mk = bays[bay_index][1];
grid_insert(fn, mk);
