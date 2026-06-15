// =====================================================================
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


// ============================ params.scad ============================
// =====================================================================
//  params.scad  -  Zentrale Parameter (einzige Wahrheitsquelle)
//  Rechteckiger 4-Bürsten-Halter, Voronoi-Relief, modulare Einsätze.
//  Eigenentwicklung; nur die funktionalen Schnittstellenmaße an
//  Oral-B-/Sonicare-Referenzteilen vermessen (Geräte-Passung):
//    - Oral-B Cavity-Tiefe ~21 mm, Ladeöffnung oval 42x55, Zapfen 8x9,6->7,5x9
//    - Sonicare Ladeöffnung 40 x 55 mm (D-Form, Halbkreis vorne), Höhe 20 mm
// =====================================================================

// ---- Korpus (Wanne) -------------------------------------------------
//  (n_bays steht weiter unten in der Gruppe "Belegung")
bay_inner_w  = 57;    // Innenbreite je Fach in X (mm)
divider_t    = 3;     // Trennwand zwischen Fächern (mm)
wall_t       = 5.0;   // Außenwandstärke (mm) - dick genug für die bündige
                      //   senkrechte Rückwand-Nut in den Seitenwänden (statt Außenpfosten)
body_depth   = 79;    // lichte Fachtiefe in Y (Front-Innenkante .. Rückwand-Vorderkante)
floor_t      = 3.0;   // Bodenstärke (mm, jetzt geschlossen)
// Wandhöhe = Boden + größte Ladestationshöhe (+1 mm höhere Wände). Die Ladestationen
// bleiben über pf = body_height - charger_h bündig (Sockel wächst um 1 mm mit).
body_height  = 25;    // = floor_t(3) + Oral-B-Ladehöhe(21) + 1 mm höhere Wände

// ---- Einsatz-Sitz ---------------------------------------------------
insert_h     = 6.0;   // Dicke der Einsatzgitter (mm)
ledge_w      = 2.0;   // umlaufende Auflage für den Einsatz (mm)
clearance    = 0.4;   // Spiel Einsatz <-> Fach (mm, pro Seite)

// ---- Abrundung + Füße ----------------------------------------------
fillet_r     = 5.0;   // Radius aller Außenkanten/Ecken (0,5 cm)
foot_r       = 5.0;   // Fußradius (0,5 cm)
foot_h       = 5.0;   // Fußhöhe (0,5 cm)
foot_inset   = 5.0;   // Fußrand 0,5 cm von der Ecke (Mittelpunkt = inset+foot_r)

// ---- Steck-System: separate Füße (Kabelbox-Stil) -------------------
//  Füße werden von UNTEN in den Boden gesteckt (Zapfen zeigt nach oben ->
//  stützenfrei). Der Boden trägt nur Sacklöcher, kein nach unten zeigender Zapfen.
peg_d        = 5.0;   // Zapfen-Durchmesser
peg_h        = 2.0;   // Zapfen-Höhe (Steck-Tiefe)
peg_hole_d   = 5.1;   // Aufnahme-Loch im Boden (snug, +0,1 mm Spiel)
peg_hole_dep = 2.0;   // Sackloch-Tiefe im Boden (floor_t=3 -> 1 mm bleibt stehen)

// ---- Feder & Nut: Einsatz-Schiebehaltung (Gridfinity-Stil) ---------
//  Einsatz wird von HINTEN eingeschoben; seitliche Lippen an der Fach-
//  Oberkante übergreifen die Einsatz-Oberkante -> kein Abheben.
//  (rail_overhang darf 57-2*x > 51 lassen -> max ~2.5, sonst kollidiert die
//   Sonicare-Ladeöffnung 51 mit dem "Mund")
rail_overhang = 2.0;  // Lippen-Überstand nach innen (X) = Eingriff
rail_thick    = 3.0;  // Höhe der Lippe/Feder (Z) — kräftiger, gut sichtbar
rail_clear    = 0.25; // Spiel Feder <-> Lippe
rail_cham     = 0.8;  // 45°-Fase (stützenfreier Druck der Lippen-Unterseite)

// ---- separate Rückwand + hintere Eckpfosten (Kabelbox-Stil) --------
//  Die Rückwand ist so TIEF wie die hinteren Eckpfosten (rear_wall_t) -> hinten
//  BÜNDIG mit den Pfosten. Sie wird von OBEN senkrecht eingeschoben; ihre
//  seitliche Feder (rear_tongue_d tief, VORN an der Platte) greift in eine
//  senkrechte Nut in den massiven Pfosten. Dahinter steht rear_wall_t -
//  rear_tongue_d - rear_clear = 10 - 4 - 0,3 = 5,7 mm Vollmaterial (weit weg von
//  der gerundeten Hinterkante) -> Feder in Y gefangen, robust, kein dünner Steg.
rear_wall_t    = 10.0; // Platten-/Pfostentiefe (Y) -> Rückwand bündig mit Pfosten
rear_clear     = 0.3;  // Spiel Rückwand rundum
rear_tongue_w  = 2.5;  // Feder-Breite der Rückwand (X-Eingriff, in die Pfosten-Nut)
rear_tongue_d  = 4.0;  // Feder-Tiefe (Y) vorn an der Platte -> Eingriff in die Pfosten-Nut
rear_lead      = 1.5;  // Einführfase unten an der Rückwand-Feder
floor_groove_d = 1.5;  // Boden-Nut-Tiefe für die Rückwand-Unterkante

// ---- Kabelloch in der Rückwand: nach UNTEN offen (Stecker passt durch) -
cable_hole_w  = 12;   // Breite des Kabel-Schlitzes je Fach (X)
cable_hole_h  = 11;   // Oberkante des Schlitzes über dem Boden (Z), unten offen

// ---- Voronoi --------------------------------------------------------
voro_seed     = 7;    // Zufalls-Seed (deterministisch)
voro_cell     = 12;   // Zellabstand Einsätze (mm)
voro_cell_face = 7;   // Zellabstand Korpus-Flächen (feiner, schmales Band)
voro_strut   = 1.8;   // Stegbreite (mm)
relief_h     = 0.4;   // Reliefhöhe Korpus + Rückwand (erhaben, ~2 Lagen, nur Deko)
relief_insert_h = 0.2; // Reliefhöhe Einschübe (1 Lage, Muster auf geschlossener Platte)

// ---- Ladestations-Maße (für flächenbündiges Abschließen) ------------
charger_h_orb = 21;   // Oral-B Ladestationshöhe (aus Referenz-Cavity ~21)
charger_h_son = 20;   // Sonicare Ladestationshöhe (gemessen)
// Oral-B Ladeöffnung: OVAL (Ellipse), aus chargeur-Gitter gemessen
orb_charger_x = 41;     // oval Breite (X, quer)  -- 1 mm schmaler
orb_charger_y = 54;     // oval Länge (Y)         -- 1 mm weniger tief
// Sonicare: D-Kontur (quer ins Fach). Vorne voller Halbkreis (Ø = Breite).
son_charger_x = 39;     // D-Breite (X, quer)     -- 1 mm schmaler
son_charger_y = 53;     // D-Tiefe (Y)            -- 2 mm weniger tief
son_charger_fit = 1.0;  // Spiel rundum für die Ladestation (mm)
// Kabelrinne an der GERADEN D-Kante, Unterseite des Sonicare-Einschubs
son_cable_w   = 5.0;    // Breite der halbrunden Kabelrinne (X)
son_cable_h   = 2.0;    // Höhe der Kabelrinne (Z, von der Unterseite hoch)

// ---- Ständer-Zapfen je Marke (Bürste aufstecken) -------------------
// Oral-B: OVALER, sich verjüngender Zapfen (Mesh-Schnitt Ladestation_OralB_ständer.3mf:
//   Fuß 8,05x9,58 -> Spitze ~7,5x9,0, Höhe 12,5 über Scheibe; Langachse Y)
orb_peg_base = [8, 9.6];    // [X quer, Y längs] am Fuß
orb_peg_tip  = [7.5, 9];    // an der Spitze (leichte Verjüngung)
orb_peg_h    = 12.5;        // Schafthöhe über dem Einsatz
// Sonicare: runder Zapfen Ø5,5 (gewuenscht; Referenz gemessen ~6,8)
son_peg_d    = 5.5;
son_peg_h    = 8.5;
peg_collar   = 2.5;       // ovaler/runder Sockel-Überstand am Fuß
peg_chamfer  = 0.8;       // kleine Fase an der Zapfenspitze

collar_t  = 3.0;  // Verstärkungs-Kragen um Lade-Öffnungen (mm)

// ---- Bay-Belegung (konfigurierbar) ---------------------------------
//  Anzahl Module + Typ je Fach. Typ = Funktion (Ständer/Laden) + Marke.
/* [Belegung] */
n_bays = 4; // [1,2,3,4]
bay1 = "stand_orb";  // [stand_orb:OralB Ständer, charge_orb:OralB Laden, stand_son:Sonicare Ständer, charge_son:Sonicare Laden, tray:Ablage]
bay2 = "charge_orb"; // [stand_orb:OralB Ständer, charge_orb:OralB Laden, stand_son:Sonicare Ständer, charge_son:Sonicare Laden, tray:Ablage]
bay3 = "charge_son"; // [stand_orb:OralB Ständer, charge_orb:OralB Laden, stand_son:Sonicare Ständer, charge_son:Sonicare Laden, tray:Ablage]
bay4 = "stand_son";  // [stand_orb:OralB Ständer, charge_orb:OralB Laden, stand_son:Sonicare Ständer, charge_son:Sonicare Laden, tray:Ablage]

// Typ-String -> [funktion, marke, label]
function _baytype(s) =
    s == "stand_orb"  ? ["stand",  "orb", "OralB-Staender"]    :
    s == "charge_orb" ? ["charge", "orb", "OralB-Laden"]       :
    s == "stand_son"  ? ["stand",  "son", "Sonicare-Staender"] :
    s == "charge_son" ? ["charge", "son", "Sonicare-Laden"]    :
                        ["tray",   "-",   "Ablage"];   // komplett geschlossen, kein Zapfen/Öffnung
_baysel = [bay1, bay2, bay3, bay4];
bays = [ for (i = [0 : n_bays - 1]) _baytype(_baysel[i]) ];

// ---- abgeleitete Maße / Helfer (NICHT ändern) ----------------------
inner_w = n_bays*bay_inner_w + (n_bays-1)*divider_t;
outer_w = inner_w + 2*wall_t;
outer_d = wall_t + body_depth + rear_wall_t;         // Front-Wand + Fachtiefe + bündige Rückwand/Pfosten

// 4 Fuß-/Sackloch-Positionen (gemeinsame Wahrheitsquelle für Boden + Füße)
function foot_pts() = let (m = foot_inset + foot_r)
    [[m, m], [outer_w - m, m], [m, outer_d - m], [outer_w - m, outer_d - m]];

// Rückwand füllt die Pfostenzone bündig; ihre Feder greift vorn in die Pfosten-Nut.
rear_wall_y0 = outer_d - rear_wall_t;                // Vorderkante der Rückwand (Y) = wall_t + body_depth
insert_depth = rear_wall_y0 - rear_clear - wall_t;   // Einsatz-Tiefe (Front..Rückwand)

function charger_h(fn, mk) =
    (fn != "charge") ? 0 : (mk == "orb" ? charger_h_orb : charger_h_son);

$fn = 32;


// ============================ voronoi.scad ============================
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


// ============================ voronoi_data.scad ============================
// AUTO-GENERIERT von gen_voronoi.py - nicht von Hand editieren.
// cell_face=7.0 cell_insert=12.0 seed=7

// voro_face_long: Rechteck 237.0 x 15.0 mm, 149 Segmente
voro_face_long = [
  [8.057,0.000,4.064,1.466],
  [2.347,-0.000,4.064,1.466],
  [0.000,8.369,3.865,8.555],
  [3.865,8.555,4.064,1.466],
  [10.020,0.000,14.888,5.811],
  [14.888,5.811,19.922,0.000],
  [133.093,0.000,136.962,0.253],
  [137.360,0.000,136.962,0.253],
  [3.865,8.555,3.995,8.778],
  [2.123,15.000,3.995,8.778],
  [166.082,0.000,168.025,0.646],
  [168.590,-0.000,168.025,0.646],
  [111.004,7.512,113.559,0.000],
  [111.004,7.512,118.872,6.561],
  [118.872,6.561,117.839,0.000],
  [121.921,8.654,118.872,6.561],
  [121.921,8.654,118.935,15.000],
  [110.378,7.989,114.326,15.000],
  [110.378,7.989,111.004,7.512],
  [126.901,0.000,125.109,7.769],
  [121.921,8.654,125.109,7.769],
  [25.976,15.000,27.423,7.986],
  [27.423,7.986,29.169,7.932],
  [33.288,15.000,29.169,7.932],
  [34.285,0.000,32.543,6.090],
  [23.204,0.000,26.665,7.598],
  [27.423,7.986,26.665,7.598],
  [29.169,7.932,32.543,6.090],
  [58.137,15.000,54.575,13.526],
  [53.571,15.000,54.575,13.526],
  [90.569,0.000,90.192,0.458],
  [90.192,0.458,89.212,0.000],
  [110.378,7.989,105.568,7.750],
  [105.568,7.750,104.761,-0.000],
  [61.033,15.000,63.604,7.683],
  [54.575,13.526,53.370,10.662],
  [53.370,10.662,59.992,5.142],
  [63.604,7.683,59.992,5.142],
  [55.885,0.000,59.238,1.214],
  [54.512,0.000,48.967,7.905],
  [53.370,10.662,48.967,7.905],
  [59.992,5.142,59.238,1.214],
  [59.238,1.214,60.623,0.000],
  [17.960,15.000,17.723,10.455],
  [10.364,15.000,9.668,10.140],
  [17.723,10.455,14.856,8.271],
  [14.856,8.271,9.668,10.140],
  [26.665,7.598,17.723,10.455],
  [3.995,8.778,9.668,10.140],
  [14.888,5.811,14.856,8.271],
  [145.035,15.000,144.505,14.715],
  [147.358,4.689,152.226,6.167],
  [147.358,4.689,145.717,6.743],
  [151.956,15.000,153.767,8.089],
  [145.717,6.743,144.505,14.715],
  [153.767,8.089,152.226,6.167],
  [146.190,0.734,147.358,4.689],
  [146.190,0.734,146.662,0.000],
  [156.932,0.000,152.226,6.167],
  [143.815,0.000,146.190,0.734],
  [166.787,8.049,166.355,15.000],
  [166.787,8.049,160.843,8.137],
  [159.441,8.978,160.843,8.137],
  [159.441,8.978,159.317,15.000],
  [168.025,0.646,168.368,6.774],
  [168.368,6.774,166.787,8.049],
  [159.108,0.000,160.843,8.137],
  [153.767,8.089,159.441,8.978],
  [136.962,0.253,137.917,6.258],
  [145.717,6.743,139.674,6.896],
  [137.917,6.258,139.674,6.896],
  [144.505,14.715,143.465,15.000],
  [139.674,6.896,140.216,15.000],
  [98.829,7.247,104.569,8.550],
  [98.829,7.247,97.284,7.639],
  [97.284,7.639,94.915,15.000],
  [104.569,8.550,103.256,15.000],
  [105.568,7.750,104.569,8.550],
  [97.519,0.000,98.829,7.247],
  [90.192,0.458,88.990,5.441],
  [88.990,5.441,97.284,7.639],
  [91.075,15.000,88.353,6.113],
  [88.353,6.113,88.990,5.441],
  [68.533,15.000,69.379,9.029],
  [63.604,7.683,67.012,7.403],
  [69.379,9.029,67.012,7.403],
  [67.012,7.403,68.340,0.000],
  [181.767,7.379,183.106,0.000],
  [181.767,7.379,178.290,6.025],
  [178.290,6.025,176.867,0.000],
  [172.221,8.051,168.368,6.774],
  [172.221,8.051,178.290,6.025],
  [172.221,8.051,174.468,15.000],
  [183.264,8.683,182.609,15.000],
  [183.264,8.683,181.767,7.379],
  [132.479,8.592,126.949,9.056],
  [132.479,8.592,134.446,9.420],
  [134.446,9.420,136.463,15.000],
  [126.949,9.056,128.279,15.000],
  [132.791,0.000,132.479,8.592],
  [125.109,7.769,126.949,9.056],
  [137.917,6.258,134.446,9.420],
  [233.140,0.000,234.711,7.471],
  [234.711,7.471,237.000,8.285],
  [234.711,7.471,232.738,8.653],
  [232.738,8.653,230.881,15.000],
  [229.248,0.000,226.265,6.430],
  [232.738,8.653,227.566,7.831],
  [226.265,6.430,227.566,7.831],
  [226.265,6.430,221.327,5.935],
  [221.649,-0.000,221.327,5.935],
  [39.585,15.000,37.445,7.912],
  [43.300,15.000,48.102,7.834],
  [37.445,7.912,41.695,5.668],
  [41.695,5.668,47.411,7.165],
  [48.102,7.834,47.411,7.165],
  [32.543,6.090,37.445,7.912],
  [48.967,7.905,48.102,7.834],
  [40.139,0.000,41.695,5.668],
  [46.538,0.000,47.411,7.165],
  [79.755,0.000,81.211,7.507],
  [72.483,0.000,75.565,7.997],
  [80.625,8.016,76.900,8.469],
  [80.625,8.016,81.211,7.507],
  [76.900,8.469,75.565,7.997],
  [88.353,6.113,81.211,7.507],
  [69.379,9.029,75.565,7.997],
  [82.241,15.000,80.625,8.016],
  [74.912,15.000,76.900,8.469],
  [227.566,7.831,225.062,15.000],
  [221.327,5.935,218.227,8.687],
  [218.227,8.687,222.535,15.000],
  [215.134,8.479,212.271,4.887],
  [215.134,8.479,211.153,15.000],
  [204.736,7.393,205.663,15.000],
  [204.736,7.393,206.931,5.724],
  [206.931,5.724,212.271,4.887],
  [218.227,8.687,215.134,8.479],
  [198.014,0.000,197.398,5.551],
  [188.447,0.000,188.537,6.631],
  [188.537,6.631,192.841,7.801],
  [192.841,7.801,196.324,6.721],
  [197.398,5.551,196.324,6.721],
  [204.736,7.393,197.398,5.551],
  [204.362,0.000,206.931,5.724],
  [183.264,8.683,188.537,6.631],
  [192.095,15.000,192.841,7.801],
  [199.903,15.000,196.324,6.721],
  [212.271,4.887,212.717,0.000]
];

// voro_face_short: Rechteck 84.0 x 15.0 mm, 49 Segmente
voro_face_short = [
  [84.000,7.584,79.073,8.229],
  [79.073,8.229,80.166,0.000],
  [41.132,10.006,41.830,15.000],
  [41.132,10.006,37.168,8.598],
  [37.168,8.598,33.151,15.000],
  [18.123,7.039,28.105,6.773],
  [18.123,7.039,19.908,14.856],
  [28.105,6.773,26.802,15.000],
  [19.908,14.856,20.191,15.000],
  [17.433,6.337,18.123,7.039],
  [17.433,6.337,11.642,7.244],
  [19.485,15.000,19.908,14.856],
  [9.844,15.000,11.642,7.244],
  [34.946,5.937,29.161,5.498],
  [34.946,5.937,37.711,0.000],
  [29.161,5.498,27.069,0.000],
  [37.168,8.598,34.946,5.937],
  [28.105,6.773,29.161,5.498],
  [17.433,6.337,18.742,0.000],
  [65.309,5.782,65.117,0.000],
  [65.309,5.782,71.157,6.176],
  [71.157,6.176,72.231,0.000],
  [63.160,7.056,65.309,5.782],
  [63.160,7.056,57.741,5.035],
  [57.741,5.035,57.181,0.000],
  [56.046,6.386,48.262,7.231],
  [56.046,6.386,56.332,15.000],
  [48.262,7.231,50.955,15.000],
  [57.741,5.035,56.046,6.386],
  [51.398,-0.000,47.766,6.936],
  [47.766,6.936,48.262,7.231],
  [41.132,10.006,46.619,6.740],
  [46.619,6.740,47.766,6.936],
  [81.071,15.000,78.540,8.800],
  [78.540,8.800,73.718,8.863],
  [73.718,8.863,70.419,15.000],
  [79.073,8.229,78.540,8.800],
  [71.157,6.176,73.718,8.863],
  [63.228,14.438,64.518,15.000],
  [63.228,14.438,61.974,15.000],
  [63.160,7.056,63.228,14.438],
  [3.812,15.000,3.265,6.064],
  [11.642,7.244,9.586,5.534],
  [9.586,5.534,3.265,6.064],
  [9.586,5.534,9.741,0.000],
  [46.619,6.740,43.679,0.000],
  [3.755,0.000,3.036,5.911],
  [0.000,5.637,3.036,5.911],
  [3.265,6.064,3.036,5.911]
];

// voro_insert: Rechteck 57.0 x 79.0 mm, 84 Segmente
voro_insert = [
  [0.000,72.754,5.210,72.672],
  [5.210,72.672,6.730,71.460],
  [6.730,71.460,8.123,60.556],
  [0.000,61.509,8.123,60.556],
  [8.308,79.000,5.210,72.672],
  [17.599,79.000,19.310,71.867],
  [19.310,71.867,6.730,71.460],
  [0.000,45.682,6.312,43.758],
  [10.060,59.330,8.123,60.556],
  [10.060,59.330,7.883,45.322],
  [6.312,43.758,7.883,45.322],
  [57.000,42.860,51.714,42.379],
  [57.000,31.505,49.360,30.993],
  [51.714,42.379,49.360,30.993],
  [10.060,59.330,20.947,63.304],
  [19.310,71.867,21.929,68.230],
  [21.929,68.230,20.947,63.304],
  [21.929,68.230,33.984,73.375],
  [34.191,79.000,33.984,73.375],
  [33.737,0.000,36.830,1.490],
  [36.830,1.490,38.199,0.000],
  [7.883,45.322,23.361,47.310],
  [20.947,63.304,23.478,59.402],
  [23.478,59.402,23.849,47.834],
  [23.849,47.834,23.361,47.310],
  [33.984,73.375,35.780,72.118],
  [35.780,72.118,47.904,74.200],
  [47.904,74.200,48.408,79.000],
  [49.717,55.894,46.873,60.235],
  [49.717,55.894,48.239,45.800],
  [48.239,45.800,37.570,44.950],
  [46.873,60.235,40.328,61.129],
  [37.570,44.950,36.298,46.216],
  [36.298,46.216,37.004,58.090],
  [40.328,61.129,37.004,58.090],
  [57.000,56.347,49.717,55.894],
  [52.323,69.154,57.000,69.614],
  [52.323,69.154,46.873,60.235],
  [51.714,42.379,48.239,45.800],
  [48.082,29.012,37.056,31.730],
  [48.082,29.012,49.360,30.993],
  [37.056,31.730,35.474,33.869],
  [35.474,33.869,37.570,44.950],
  [35.780,72.118,40.328,61.129],
  [52.323,69.154,47.904,74.200],
  [35.474,33.869,23.921,34.048],
  [23.921,34.048,23.361,47.310],
  [23.849,47.834,36.298,46.216],
  [23.478,59.402,37.004,58.090],
  [57.000,9.612,52.914,4.929],
  [57.000,18.998,50.079,21.452],
  [52.914,4.929,44.356,13.049],
  [44.356,13.049,47.307,18.708],
  [47.307,18.708,50.079,21.452],
  [52.636,0.000,52.914,4.929],
  [48.082,29.012,50.079,21.452],
  [36.228,7.737,44.356,13.049],
  [36.228,7.737,36.830,1.490],
  [37.056,31.730,33.336,22.303],
  [33.336,22.303,47.307,18.708],
  [19.659,5.706,17.790,9.379],
  [19.659,5.706,35.991,7.933],
  [17.790,9.379,24.205,19.245],
  [35.991,7.933,29.077,18.203],
  [29.077,18.203,24.205,19.245],
  [19.831,0.000,19.659,5.706],
  [36.228,7.737,35.991,7.933],
  [33.336,22.303,29.077,18.203],
  [6.312,43.758,6.965,39.808],
  [0.000,31.316,6.965,39.808],
  [0.000,8.806,6.260,8.531],
  [6.260,8.531,6.478,0.000],
  [8.143,10.615,17.790,9.379],
  [8.143,10.615,6.260,8.531],
  [7.152,18.640,22.253,21.849],
  [7.152,18.640,5.559,20.979],
  [5.559,20.979,13.684,32.257],
  [13.684,32.257,20.169,30.490],
  [20.169,30.490,22.253,21.849],
  [8.143,10.615,7.152,18.640],
  [24.205,19.245,22.253,21.849],
  [0.000,23.061,5.559,20.979],
  [6.965,39.808,13.684,32.257],
  [23.921,34.048,20.169,30.490]
];

voro_dims = [[247.00,25.00],[94.00,25.00],[57.00,79.00]];


// ============================ body.scad ============================
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

// Steck-System: der Boden trägt nur Sacklöcher (von unten) für die separaten
// Füße (siehe foot.scad) -> kein nach unten zeigender Zapfen, stützenfrei.
module foot_holes() {
    eps = 0.05;
    for (p = foot_pts())
        translate([p[0], p[1], -eps])
            cylinder(d = peg_hole_d, h = peg_hole_dep + eps, $fn = 32);
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
                // Voronoi-Relief (eingerückt um fillet_r) auf Front + 2 Seiten
                // (Rückseite trägt die separate Rückwand -> dort eigenes Relief)
                relief_front(outer_w, body_height, voro_face_long,  voro_strut, relief_h, fillet_r);
                relief_left (outer_d, body_height, voro_face_short, voro_strut, relief_h, fillet_r);
                relief_right(outer_w, outer_d, body_height, voro_face_short, voro_strut, relief_h, fillet_r);
            }
            bay_cutouts();
            rear_cut();
            foot_holes();
        }
        _body_round_env();
    }
}


// ============================ grid.scad ============================
// =====================================================================
//  grid.scad  -  Einsteckgitter im Voronoi-Stil (ein Fach)
//  Aufruf:  openscad -D bay_index=0 -o grid0.stl grid.scad
//  stand : Voronoi-Panel + zentraler Zapfen (Bürste aufstecken)
//          orb Ø10 x 14 | son Ø5,5 x 8,5
//  charge: Voronoi-Panel + Öffnung  orb: Ø42 rund | son: D-Kontur 51x63
// =====================================================================


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


// ============================ rear_wall.scad ============================
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


// ============================ foot.scad ============================
// =====================================================================
//  foot.scad  -  separater Steck-Fuß (Kabelbox-Stil)
//  Zylinder Ø2*foot_r × foot_h mit Zapfen Ø peg_d × peg_h nach OBEN; wird
//  von unten in das Boden-Sackloch gesteckt. Zapfen zeigt nach oben ->
//  stützenfrei druckbar (Fußkörper liegt beim Druck auf der Platte).
//  Render einzeln:  openscad -o foot.stl foot.scad
// =====================================================================

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
