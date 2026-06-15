// =====================================================================
//  grid.scad  -  Einsteckgitter im Voronoi-Stil (ein Fach)
//  Aufruf:  openscad -D bay_index=0 -o grid0.stl grid.scad
//  stand : Voronoi-Panel + zentraler Zapfen (Bürste aufstecken)
//          orb Ø10 x 14 | son Ø5,5 x 8,5
//  charge: Voronoi-Panel + Öffnung  orb: Ø42 rund | son: D-Kontur 51x63
// =====================================================================
include <params.scad>
include <voronoi_data.scad>
use <voronoi.scad>

bay_index = 0;   // per -D: 0..3 = Fach
part_id   = -1;  // per -D: -1 = Fach (bay_index); 4 = Ablage (tray); 5 = Becher (cup)

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

// v2: GESCHLOSSENE solide Platte (das Muster kommt als dünnes Relief oben drauf).
module grid_panel(w, d)
    linear_extrude(height = insert_h) square([w, d]);

// Dünnes Voronoi-Relief auf der OBERSEITE des Einschubs (1 Lage, nur Deko).
// Rand um rail_overhang+ frei halten -> kollidiert nicht mit der Fach-Lippe.
module insert_relief(w, d) {
    m = rail_overhang + 1.5; ov = 0.4;
    translate([0, 0, insert_h - ov])
        linear_extrude(relief_insert_h + ov)
            intersection() {
                translate([m, m]) square([w - 2*m, d - 2*m]);
                voro_web_2d(voro_insert, voro_strut);
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

// Halbrunde Kabelrinne (son_cable_w breit x son_cable_h hoch) an der GERADEN
// (hinteren, +Y) D-Kante auf der UNTERSEITE -> Sonicare-Kabel liegt sauber nach
// hinten. Wird in grid_insert relativ zum Öffnungszentrum subtrahiert.
module son_cable_notch(grow) {
    rr = son_cable_w / 2;
    zc = son_cable_h - rr;                      // Kreismitte -> Oberkante bei son_cable_h
    ys = (son_charger_y + 2*grow)/2 - 1;        // an der geraden D-Kante (leicht in die Öffnung)
    translate([0, ys, zc]) rotate([-90, 0, 0])
        cylinder(r = rr, h = 60, $fn = 32);     // Achse +Y, bis hinter den Einschubrand
}

// rounded-rect Helper (für den Becher)
module rrect(w, d, r)
    translate([r, r]) offset(r = r, $fn = 48) square([w - 2*r, d - 2*r]);

// ---- Becher (grid5) -------------------------------------------------
// Gerundete Außenschale: Footprint exakt 0..w / 0..d, vertikale Kanten + obere
// Kante mit r gerundet, Boden flach (für die Schiebe-Basis). offset(-r) rrect ist
// bereits um r eingerückt -> minkowski(sphere r) stellt 0..w/0..d wieder her.
module cup_outer(w, d, h, r)
    intersection() {
        minkowski() {
            linear_extrude(max(0.01, h - r)) offset(-r) rrect(w, d, r);
            sphere(r = r, $fn = 24);
        }
        linear_extrude(h) square([w, d]);
    }

// Voronoi-Relief auf den 4 Außenwänden (nur oberhalb der Schiebe-Basis).
module cup_relief(w, d, h, m)
    intersection() {
        union() {
            relief_front(w,    h, voro_cup_w, voro_strut, relief_h, m);
            relief_back (w, d, h, voro_cup_w, voro_strut, relief_h, m);
            relief_left (d, h, voro_cup_d, voro_strut, relief_h, m);
            relief_right(w, d, h, voro_cup_d, voro_strut, relief_h, m);
        }
        translate([-50, -50, insert_h]) cube([w + 100, d + 100, h]);
    }

// Becher über die volle Einschub-Fläche: gerundete Schale, hohl (oben offen),
// unten T-Profil-Schiebebasis (= Boden), Voronoi außen.
module cup() {
    w = bay_inner_w  - 2 * clearance;
    d = insert_depth - 2 * clearance;
    H = cup_h; wt = cup_wall; rr = cup_round; bh = insert_h;
    union() {
        intersection() { linear_extrude(bh) square([w, d]); insert_envelope(w, d); }   // Basis
        difference() {
            cup_outer(w, d, H, rr);                                                    // Außenschale
            translate([wt, wt, bh]) linear_extrude(H) rrect(w - 2*wt, d - 2*wt, max(0.8, rr - wt)); // Hohlraum, oben offen
        }
        cup_relief(w, d, H, rr);
    }
}

module grid_insert(fn, mk) {
    w = bay_inner_w  - 2 * clearance;
    d = insert_depth - 2 * clearance;          // lässt hinten Platz für die Rückwand
    cx = w / 2; cy = d / 2;
    if (fn == "stand") {
        union() {
            intersection() { grid_panel(w, d); insert_envelope(w, d); }
            insert_relief(w, d);
            translate([cx, cy, 0])
                if (mk == "orb") peg_orb(); else peg_son();
        }
    } else if (fn == "tray") {  // Ablage: komplett geschlossene Platte + Relief
        union() {
            intersection() { grid_panel(w, d); insert_envelope(w, d); }
            insert_relief(w, d);
        }
    } else if (fn == "cup") {   // Becher: hoher gerundeter Behälter, Voronoi außen
        cup();
    } else {  // charge: geschlossene Platte + Relief, dann Ladeöffnung ausschneiden
        grow = son_charger_fit;
        difference() {
            union() {
                intersection() { grid_panel(w, d); insert_envelope(w, d); }
                insert_relief(w, d);
            }
            translate([cx, cy, 0]) charge_cut(mk, grow);
            // Relief-Schicht ueber der Oeffnung mitraeumen (charge_cut endet snug
            // an der Plattenoberkante, das duenne Relief darueber bliebe sonst stehen)
            translate([cx, cy, insert_h - 0.05])
                linear_extrude(relief_insert_h + 0.1) charge_open_2d(mk, grow);
            // Sonicare: halbrunde Kabelrinne an der geraden D-Kante (Unterseite)
            if (mk == "son") translate([cx, cy, 0]) son_cable_notch(grow);
        }
    }
}

_fn = part_id == 4 ? "tray" : part_id == 5 ? "cup" : bays[bay_index][0];
_mk = part_id >= 4 ? "-" : bays[bay_index][1];
grid_insert(_fn, _mk);
