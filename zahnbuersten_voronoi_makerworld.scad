// =====================================================================
//  Elektr. Zahnbuerstenhalter (Oral-B + Sonicare), frei konfigurierbar
//  EIN-DATEI / self-contained fuer MakerWorld (Parametric Model Maker).
//  Konfigurierbar: Anzahl Module (1-4) + je Fach Marke & Funktion.
//  Auto-zusammengefuehrt aus params/voronoi_data/voronoi/body/grid/rear_wall.
// =====================================================================

/* [Teil-Auswahl] */
// Was erzeugen? "platte" = alle Teile druckfertig auf einer X2D-Platte.
part = "platte"; // [platte:Alle Teile auf X2D-Platte, montage:Montage-Vorschau, korpus:Korpus, gitter1:Einsatz Fach 1, gitter2:Einsatz Fach 2, gitter3:Einsatz Fach 3, gitter4:Einsatz Fach 4, rueckwand:Rueckwand]

/* [Hinweis] */
// Das Voronoi-Flaechenrelief ist fuer 4 Faecher vorberechnet; bei weniger Faechern
// wird es vorne nur beschnitten (rein optisch). Die Gitter-Muster in den Faechern
// sind unabhaengig und immer korrekt.

// ============================ params.scad ============================
// =====================================================================
//  params.scad  -  Zentrale Parameter (einzige Wahrheitsquelle)
//  Rechteckiger 4-Bürsten-Halter, Voronoi-Relief, modulare Einsätze.
//  Eigenentwicklung; nur die funktionalen Schnittstellenmaße an
//  Oral-B-/Sonicare-Referenzteilen vermessen (Geräte-Passung):
//    - Oral-B Cavity-Tiefe ~21 mm, Ladeöffnung oval 42x55, Zapfen 8x9,6->7,5x9
//    - Sonicare Ladestation 63 x 51 mm (D-Form), Höhe 20 mm (Holder_v2)
// =====================================================================

// ---- Korpus (Wanne) -------------------------------------------------
//  (n_bays steht weiter unten in der Gruppe "Belegung")
bay_inner_w  = 57;    // Innenbreite je Fach in X (mm)
divider_t    = 3;     // Trennwand zwischen Fächern (mm)
wall_t       = 5.0;   // Außenwandstärke (mm) - dick genug für die bündige
                      //   senkrechte Rückwand-Nut in den Seitenwänden (statt Außenpfosten)
body_depth   = 78;    // Innentiefe in Y (mm)
floor_t      = 3.0;   // Bodenstärke (mm, jetzt geschlossen)
// Wandhöhe = Boden + größte Ladestationshöhe -> Ladestation schließt bündig ab
body_height  = 24;    // = floor_t(3) + Oral-B-Ladehöhe(21); bei Änderung anpassen

// ---- Einsatz-Sitz ---------------------------------------------------
insert_h     = 6.0;   // Dicke der Einsatzgitter (mm)
ledge_w      = 2.0;   // umlaufende Auflage für den Einsatz (mm)
clearance    = 0.4;   // Spiel Einsatz <-> Fach (mm, pro Seite)

// ---- Abrundung + Füße ----------------------------------------------
fillet_r     = 5.0;   // Radius aller Außenkanten/Ecken (0,5 cm)
foot_r       = 5.0;   // Fußradius (0,5 cm)
foot_h       = 5.0;   // Fußhöhe (0,5 cm)
foot_inset   = 5.0;   // Fußrand 0,5 cm von der Ecke (Mittelpunkt = inset+foot_r)

// ---- Feder & Nut: Einsatz-Schiebehaltung (Gridfinity-Stil) ---------
//  Einsatz wird von HINTEN eingeschoben; seitliche Lippen an der Fach-
//  Oberkante übergreifen die Einsatz-Oberkante -> kein Abheben.
//  (rail_overhang darf 57-2*x > 51 lassen -> max ~2.5, sonst kollidiert die
//   Sonicare-Ladeöffnung 51 mit dem "Mund")
rail_overhang = 2.0;  // Lippen-Überstand nach innen (X) = Eingriff
rail_thick    = 3.0;  // Höhe der Lippe/Feder (Z) — kräftiger, gut sichtbar
rail_clear    = 0.25; // Spiel Feder <-> Lippe
rail_cham     = 0.8;  // 45°-Fase (stützenfreier Druck der Lippen-Unterseite)

// ---- separate Rückwand (von oben senkrecht in die Seitenwände) -----
//  Die senkrechte Nut liegt BÜNDIG in den (dicken) Seitenwänden -> keine
//  Außenpfosten. Einsatz läuft innerhalb wall_t, Nut außerhalb -> kollisionsfrei.
rear_wall_t    = 4.0; // Plattendicke (Y)
rear_clear     = 0.3; // Spiel Rückwand rundum
rear_tongue_w  = 2.5; // Feder-Breite der Rückwand (X-Eingriff, in die Wand-Nut)
rear_lead      = 1.5; // Einführfase unten an der Rückwand-Feder
rear_back_skin = 1.2; // Wand-Material HINTER der Nut -> Nut hinten ZU (Feder
                      //   in Y gefangen, Rückwand sitzt fest statt lose)
floor_groove_d = 1.5; // Boden-Nut-Tiefe für die Rückwand-Unterkante
// (Wand-Skin außen = wall_t - rear_tongue_w - rear_clear = 2.2 mm)

// ---- Kabelloch in der Rückwand: nach UNTEN offen (Stecker passt durch) -
cable_hole_w  = 12;   // Breite des Kabel-Schlitzes je Fach (X)
cable_hole_h  = 11;   // Oberkante des Schlitzes über dem Boden (Z), unten offen

// ---- Voronoi --------------------------------------------------------
voro_seed     = 7;    // Zufalls-Seed (deterministisch)
voro_cell     = 12;   // Zellabstand Einsätze (mm)
voro_cell_face = 7;   // Zellabstand Korpus-Flächen (feiner, schmales Band)
voro_strut   = 1.8;   // Stegbreite (mm)
relief_h     = 1.4;   // Reliefhöhe am Korpus (erhaben, mm)

// ---- Ladestations-Maße (für flächenbündiges Abschließen) ------------
charger_h_orb = 21;   // Oral-B Ladestationshöhe (aus Referenz-Cavity ~21)
charger_h_son = 20;   // Sonicare Ladestationshöhe (gemessen)
// Oral-B Ladeöffnung: OVAL (Ellipse), aus chargeur-Gitter gemessen
orb_charger_x = 42;     // oval Breite (X, quer)
orb_charger_y = 55;     // oval Länge (Y)
// Sonicare: echte D-Kontur (quer ins Fach, 51 mm in X)
son_charger_x = 51;     // D-Breite (X, quer)   -> passt in 57er Fach
son_charger_y = 63;     // D-Länge (Y)
son_charger_fit = 1.0;  // Spiel rundum für die Ladestation (mm)

// ---- Ständer-Zapfen je Marke (Bürste aufstecken) -------------------
// Oral-B: OVALER, sich verjüngender Zapfen (Mesh-Schnitt Ladestation_OralB_ständer.3mf:
//   Fuß 8,05x9,58 -> Spitze ~7,5x9,0, Höhe 12,5 über Scheibe; Langachse Y)
orb_peg_base = [8, 9.6];    // [X quer, Y längs] am Fuß
orb_peg_tip  = [7.5, 9];    // an der Spitze (leichte Verjüngung)
orb_peg_h    = 12.5;        // Schafthöhe über dem Einsatz
// Sonicare: runder Zapfen Ø7 (gemessen ~6,8)
son_peg_d    = 7;
son_peg_h    = 10;
peg_collar   = 2.5;       // ovaler/runder Sockel-Überstand am Fuß
peg_chamfer  = 0.8;       // kleine Fase an der Zapfenspitze

collar_t  = 3.0;  // Verstärkungs-Kragen um Lade-Öffnungen (mm)

// ---- Bay-Belegung (konfigurierbar) ---------------------------------
//  Anzahl Module + Typ je Fach. Typ = Funktion (Ständer/Laden) + Marke.
/* [Belegung] */
n_bays = 4; // [1,2,3,4]
bay1 = "stand_orb";  // [stand_orb:OralB Ständer, charge_orb:OralB Laden, stand_son:Sonicare Ständer, charge_son:Sonicare Laden]
bay2 = "charge_orb"; // [stand_orb:OralB Ständer, charge_orb:OralB Laden, stand_son:Sonicare Ständer, charge_son:Sonicare Laden]
bay3 = "charge_son"; // [stand_orb:OralB Ständer, charge_orb:OralB Laden, stand_son:Sonicare Ständer, charge_son:Sonicare Laden]
bay4 = "stand_son";  // [stand_orb:OralB Ständer, charge_orb:OralB Laden, stand_son:Sonicare Ständer, charge_son:Sonicare Laden]

// Typ-String -> [funktion, marke, label]
function _baytype(s) =
    s == "stand_orb"  ? ["stand",  "orb", "OralB-Staender"]    :
    s == "charge_orb" ? ["charge", "orb", "OralB-Laden"]       :
    s == "stand_son"  ? ["stand",  "son", "Sonicare-Staender"] :
                        ["charge", "son", "Sonicare-Laden"];
_baysel = [bay1, bay2, bay3, bay4];
bays = [ for (i = [0 : n_bays - 1]) _baytype(_baysel[i]) ];

// ---- abgeleitete Maße / Helfer (NICHT ändern) ----------------------
inner_w = n_bays*bay_inner_w + (n_bays-1)*divider_t;
outer_w = inner_w + 2*wall_t;
outer_d = body_depth + 2*wall_t;

// Rückwand sitzt ganz hinten (im alten Rückwand-Bereich); Einsatz endet davor.
rear_wall_y0 = outer_d - rear_wall_t;                // Vorderkante der Rückwand (Y)
insert_depth = rear_wall_y0 - rear_clear - wall_t;   // Einsatz-Tiefe (Front..Rückwand)

function charger_h(fn, mk) =
    (fn != "charge") ? 0 : (mk == "orb" ? charger_h_orb : charger_h_son);

$fn = 32;

// ============================ voronoi_data.scad ============================
// AUTO-GENERIERT von gen_voronoi.py - nicht von Hand editieren.
// cell_face=7.0 cell_insert=12.0 seed=7

// voro_face_long: Rechteck 237.0 x 14.0 mm, 149 Segmente
voro_face_long = [
  [135.610,-0.000,136.990,0.094],
  [137.131,0.000,136.990,0.094],
  [166.470,0.000,168.038,0.543],
  [168.492,0.000,168.038,0.543],
  [103.324,14.000,104.528,8.088],
  [104.528,8.088,105.550,7.244],
  [105.550,7.244,110.475,7.495],
  [114.139,14.000,110.475,7.495],
  [234.668,6.935,237.000,7.792],
  [234.668,6.935,232.683,8.174],
  [232.683,8.174,230.979,14.000],
  [104.528,8.088,98.797,6.737],
  [98.797,6.737,97.579,0.000],
  [105.550,7.244,104.796,0.000],
  [53.580,14.000,54.466,12.600],
  [54.466,12.600,53.485,10.270],
  [53.485,10.270,49.078,7.414],
  [43.523,14.000,47.997,7.322],
  [49.078,7.414,47.997,7.322],
  [49.078,7.414,54.278,0.000],
  [47.997,7.322,47.397,6.718],
  [47.397,6.718,46.578,0.000],
  [3.869,8.069,3.959,8.231],
  [3.869,8.069,4.058,1.352],
  [3.959,8.231,9.694,9.655],
  [4.058,1.352,7.617,0.000],
  [9.694,9.655,14.858,7.723],
  [10.299,0.000,14.888,5.478],
  [14.858,7.723,14.888,5.478],
  [0.000,7.874,3.869,8.069],
  [2.223,14.000,3.959,8.231],
  [2.529,0.000,4.058,1.352],
  [10.317,14.000,9.694,9.655],
  [17.942,14.000,17.734,9.998],
  [17.734,9.998,14.858,7.723],
  [14.888,5.478,19.633,0.000],
  [17.734,9.998,26.572,7.060],
  [26.572,7.060,23.355,0.000],
  [29.264,7.429,27.388,7.488],
  [29.264,7.429,33.094,14.000],
  [27.388,7.488,26.045,14.000],
  [26.572,7.060,27.388,7.488],
  [168.038,0.543,168.357,6.229],
  [172.282,7.572,168.357,6.229],
  [172.282,7.572,178.245,5.501],
  [178.245,5.501,176.946,0.000],
  [144.792,14.000,144.534,13.857],
  [147.292,4.132,152.321,5.709],
  [147.292,4.132,145.692,6.236],
  [152.043,14.000,153.730,7.563],
  [145.692,6.236,144.534,13.857],
  [153.730,7.563,152.321,5.709],
  [146.260,0.636,147.292,4.132],
  [146.260,0.636,146.644,0.000],
  [156.678,0.000,152.321,5.709],
  [144.277,0.000,146.260,0.636],
  [166.777,7.547,166.376,14.000],
  [166.777,7.547,160.808,7.638],
  [159.437,8.494,160.808,7.638],
  [159.437,8.494,159.324,14.000],
  [168.357,6.229,166.777,7.547],
  [159.179,0.000,160.808,7.638],
  [153.730,7.563,159.437,8.494],
  [136.990,0.094,137.882,5.703],
  [145.692,6.236,139.685,6.398],
  [137.882,5.703,139.685,6.398],
  [144.534,13.857,144.028,14.000],
  [139.685,6.398,140.194,14.000],
  [218.348,8.196,222.307,14.000],
  [218.348,8.196,215.039,7.968],
  [211.357,14.000,215.039,7.968],
  [218.348,8.196,221.337,5.419],
  [227.516,7.307,225.179,14.000],
  [227.516,7.307,226.336,5.945],
  [221.337,5.419,226.336,5.945],
  [232.683,8.174,227.516,7.307],
  [221.631,0.000,221.337,5.419],
  [226.336,5.945,229.093,0.000],
  [234.668,6.935,233.210,0.000],
  [90.456,0.000,90.119,0.427],
  [89.265,0.000,90.119,0.427],
  [98.797,6.737,97.226,7.152],
  [97.226,7.152,89.046,4.876],
  [90.119,0.427,89.046,4.876],
  [56.354,0.000,59.280,1.100],
  [59.280,1.100,60.476,0.000],
  [53.485,10.270,59.940,4.536],
  [59.940,4.536,59.280,1.100],
  [69.352,8.548,67.044,6.894],
  [69.352,8.548,68.580,14.000],
  [67.044,6.894,63.542,7.192],
  [63.542,7.192,61.150,14.000],
  [68.281,0.000,67.044,6.894],
  [59.940,4.536,63.542,7.192],
  [54.466,12.600,57.727,14.000],
  [97.226,7.152,95.022,14.000],
  [89.046,4.876,88.396,5.585],
  [88.396,5.585,90.973,14.000],
  [37.506,7.449,41.643,5.144],
  [37.506,7.449,32.603,5.549],
  [41.643,5.144,40.230,0.000],
  [32.603,5.549,34.189,0.000],
  [39.485,14.000,37.506,7.449],
  [47.397,6.718,41.643,5.144],
  [29.264,7.429,32.603,5.549],
  [178.245,5.501,181.789,6.927],
  [181.789,6.927,183.046,0.000],
  [181.789,6.927,183.241,8.239],
  [188.535,6.113,183.241,8.239],
  [188.535,6.113,188.452,-0.000],
  [196.379,6.179,199.759,14.000],
  [196.379,6.179,192.822,7.316],
  [192.822,7.316,192.129,14.000],
  [188.535,6.113,192.822,7.316],
  [182.644,14.000,183.241,8.239],
  [215.039,7.968,212.289,4.355],
  [212.289,4.355,212.687,0.000],
  [172.282,7.572,174.360,14.000],
  [132.485,8.086,126.989,8.568],
  [132.485,8.086,134.531,8.988],
  [134.531,8.988,136.343,14.000],
  [126.989,8.568,128.205,14.000],
  [132.779,0.000,132.485,8.086],
  [126.824,0.000,125.155,7.236],
  [125.155,7.236,126.989,8.568],
  [137.882,5.703,134.531,8.988],
  [119.092,14.000,121.826,8.189],
  [125.155,7.236,121.826,8.189],
  [111.052,7.038,118.843,6.045],
  [111.052,7.038,113.445,0.000],
  [118.843,6.045,117.891,0.000],
  [110.475,7.495,111.052,7.038],
  [121.826,8.189,118.843,6.045],
  [75.496,7.485,72.611,0.000],
  [75.496,7.485,76.847,7.976],
  [76.847,7.976,80.660,7.501],
  [79.820,0.000,81.183,7.032],
  [80.660,7.501,81.183,7.032],
  [69.352,8.548,75.496,7.485],
  [75.014,14.000,76.847,7.976],
  [82.164,14.000,80.660,7.501],
  [88.396,5.585,81.183,7.032],
  [205.622,14.000,204.760,6.925],
  [212.289,4.355,206.864,5.241],
  [204.760,6.925,206.864,5.241],
  [196.379,6.179,197.422,4.998],
  [204.760,6.925,197.422,4.998],
  [197.422,4.998,197.977,0.000],
  [206.864,5.241,204.512,0.000]
];

// voro_face_short: Rechteck 78.0 x 14.0 mm, 43 Segmente
voro_face_short = [
  [43.985,6.243,53.112,7.976],
  [43.985,6.243,42.825,13.680],
  [53.112,7.976,49.425,14.000],
  [42.825,13.680,43.240,14.000],
  [42.825,13.680,41.390,14.000],
  [10.812,6.393,11.570,0.000],
  [10.812,6.393,17.584,4.898],
  [17.584,4.898,17.718,0.000],
  [43.985,6.243,43.476,5.322],
  [34.186,7.560,35.634,14.000],
  [34.186,7.560,36.891,3.844],
  [43.476,5.322,36.891,3.844],
  [67.118,14.000,64.768,7.099],
  [64.768,7.099,57.128,8.047],
  [57.128,8.047,57.948,14.000],
  [78.000,5.828,74.180,5.102],
  [74.180,5.102,72.480,5.955],
  [72.480,5.955,72.740,14.000],
  [74.014,0.000,74.180,5.102],
  [66.541,5.140,72.480,5.955],
  [66.541,5.140,65.977,0.000],
  [66.541,5.140,64.768,7.099],
  [11.739,14.000,9.857,7.132],
  [2.656,14.000,2.555,7.696],
  [9.857,7.132,5.923,6.142],
  [2.555,7.696,5.923,6.142],
  [0.000,7.177,2.555,7.696],
  [10.812,6.393,9.857,7.132],
  [4.887,0.000,5.923,6.142],
  [34.186,7.560,27.163,7.103],
  [26.781,0.000,25.774,4.945],
  [36.891,3.844,35.447,0.000],
  [25.774,4.945,27.163,7.103],
  [17.584,4.898,18.818,5.763],
  [25.774,4.945,18.818,5.763],
  [52.338,0.000,55.391,7.115],
  [56.112,7.324,55.391,7.115],
  [56.112,7.324,59.831,0.000],
  [53.112,7.976,55.391,7.115],
  [57.128,8.047,56.112,7.324],
  [43.476,5.322,45.915,0.000],
  [27.163,7.103,25.589,14.000],
  [18.818,5.763,19.312,14.000]
];

// voro_insert: Rechteck 57.0 x 78.0 mm, 71 Segmente
voro_insert = [
  [35.316,39.819,37.321,37.492],
  [35.316,39.819,37.741,52.637],
  [37.321,37.492,47.796,35.183],
  [37.741,52.637,48.107,53.380],
  [47.796,35.183,49.207,37.039],
  [49.207,37.039,51.902,50.074],
  [51.902,50.074,48.107,53.380],
  [57.000,50.493,51.902,50.074],
  [57.000,37.455,49.207,37.039],
  [50.370,25.442,57.000,23.303],
  [50.370,25.442,47.796,35.183],
  [53.003,8.203,57.000,11.810],
  [53.003,8.203,52.540,0.000],
  [49.850,65.283,46.419,69.671],
  [49.850,65.283,57.000,65.667],
  [46.419,69.671,51.509,78.000],
  [48.107,53.380,49.850,65.283],
  [7.275,44.723,0.000,37.531],
  [7.275,44.723,14.174,38.027],
  [14.174,38.027,5.126,25.468],
  [0.000,27.186,5.126,25.468],
  [32.893,26.269,28.397,22.606],
  [32.893,26.269,47.953,23.339],
  [28.397,22.606,36.327,10.827],
  [36.327,10.827,43.620,15.030],
  [43.620,15.030,47.953,23.339],
  [50.370,25.442,47.953,23.339],
  [37.321,37.492,32.893,26.269],
  [53.003,8.203,43.620,15.030],
  [14.174,38.027,19.921,36.609],
  [19.921,36.609,22.527,25.799],
  [5.126,25.468,7.016,23.140],
  [22.527,25.799,7.016,23.140],
  [23.958,39.975,19.921,36.609],
  [23.958,39.975,35.316,39.819],
  [28.397,22.606,24.659,23.337],
  [22.527,25.799,24.659,23.337],
  [37.741,52.637,36.253,53.942],
  [46.419,69.671,40.715,70.374],
  [36.253,53.942,37.058,67.488],
  [40.715,70.374,37.058,67.488],
  [40.715,70.374,37.558,78.000],
  [36.253,53.942,23.880,55.366],
  [37.058,67.488,23.454,68.617],
  [23.454,68.617,23.880,55.366],
  [23.958,39.975,23.329,54.845],
  [23.329,54.845,23.880,55.366],
  [6.238,11.111,8.260,13.063],
  [6.238,11.111,6.521,0.000],
  [8.260,13.063,17.310,12.034],
  [19.882,0.000,19.628,8.438],
  [17.310,12.034,19.628,8.438],
  [0.000,11.351,6.238,11.111],
  [7.016,23.140,8.260,13.063],
  [24.659,23.337,17.310,12.034],
  [36.327,10.827,36.155,10.193],
  [36.155,10.193,19.628,8.438],
  [32.387,0.000,36.952,1.918],
  [38.936,0.000,36.952,1.918],
  [36.155,10.193,36.952,1.918],
  [7.275,44.723,6.136,51.610],
  [0.000,53.325,6.136,51.610],
  [23.329,54.845,7.769,53.074],
  [6.136,51.610,7.769,53.074],
  [23.454,68.617,20.706,72.270],
  [7.769,53.074,10.219,68.834],
  [20.706,72.270,10.219,68.834],
  [20.706,72.270,21.848,78.000],
  [0.000,70.793,8.224,69.948],
  [8.224,69.948,7.195,78.000],
  [10.219,68.834,8.224,69.948]
];

voro_dims = [[247.00,24.00],[88.00,24.00],[57.00,78.00]];

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

// ============================ body.scad ============================
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


// ============================ grid.scad ============================
// =====================================================================
//  grid.scad  -  Einsteckgitter im Voronoi-Stil (ein Fach)
//  Aufruf:  openscad -D bay_index=0 -o grid0.stl grid.scad
//  stand : Voronoi-Panel + zentraler Zapfen (Bürste aufstecken)
//          orb Ø10 x 14 | son Ø7 x 10
//  charge: Voronoi-Panel + Öffnung  orb: Ø42 rund | son: D-Kontur 51x63
// =====================================================================

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
            translate([cx, cy, -0.1])
                linear_extrude(insert_h + 0.2) charge_open_2d(mk, grow);
        }
    }
}


// ============================ rear_wall.scad ============================
// =====================================================================
//  rear_wall.scad  -  separate Rückwand, von oben senkrecht eingeschoben
//   - Platte (inner_w x body_height x rear_wall_t)
//   - seitliche Federn links/rechts (breit, mit Einführfase) -> Eckpfosten-Nuten
//   - Unterkante in der Boden-Nut gelagert
//   - Voronoi-Relief außen
//   - je Fach ein nach UNTEN offener Kabel-Schlitz (Stecker passt durch)
//  Render:  openscad -o rearwall.stl rear_wall.scad
// =====================================================================

x0r = wall_t;  x1r = outer_w - wall_t;          // Plattenränder (X)
z0r = floor_t - floor_groove_d;                 // Unterkante (in Boden-Nut)
phr = body_height - z0r;

// Voronoi-Relief auf der Außenseite (gleiches Band wie Korpus-Front/Rück)
module rear_relief() {
    m = fillet_r;
    intersection() {
        translate([outer_w - m, outer_d, m]) rotate([90, 0, 180])
            voro_slab(outer_w - 2*m, body_height - 2*m, voro_face_long, voro_strut, relief_h);
        translate([wall_t, rear_wall_y0 - 1, 0])           // auf Plattengröße clippen
            cube([inner_w, rear_wall_t + relief_h + 2, body_height]);
    }
}

// seitliche Feder mit Einführfase unten (sx=0 links, 1 rechts).
// Feder ist in Y ZURÜCKGESETZT (Tiefe td), damit sie in die hinten geschlossene
// Wand-Nut passt -> in Y gefangen. Platte selbst bleibt hinten bündig (outer_d).
module rear_tongue(sx) {
    xin  = (sx == 0) ? x0r : x1r;
    xout = (sx == 0) ? x0r - rear_tongue_w : x1r + rear_tongue_w;
    lo = min(xin, xout); hi = max(xin, xout);
    blo = (sx == 0) ? lo + rear_lead : lo;             // Fase: Boden outboard zurück
    bhi = (sx == 0) ? hi : hi - rear_lead;
    td  = rear_wall_t - rear_back_skin - rear_clear;   // Feder-Tiefe (Y), zurückgesetzt
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
// Schneidet die Rückwand so, dass ihre Kanten oben/unten/hinten der Gehäuse-
// rundung folgen (statt eckig zu sein). Die Seiten (x innen) bleiben unberührt.
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


// ============================ Druckplatte (alle Teile) ============================
// Korpus + n Gitter + Rueckwand (flach gekippt, Relief oben) nebeneinander.
module _platte() {
    GAP = 8;
    gw = bay_inner_w - 2*clearance;        // Gitterbreite
    gd = insert_depth - 2*clearance;       // Gittertiefe
    row2 = outer_d + GAP;                  // Reihe Gitter
    row3 = row2 + gd + GAP;                // Reihe Rueckwand
    body();
    for (i = [0 : n_bays - 1])
        translate([i*(gw + GAP), row2, 0]) grid_insert(bays[i][0], bays[i][1]);
    // Rueckwand flach: um 90 Grad gekippt (Relief nach oben), in Reihe 3
    translate([0, row3 + body_height, -rear_wall_y0]) rotate([90, 0, 0]) rear_wall();
}

// ============================ Teil-Auswahl / Render ============================
if      (part == "platte")                    _platte();
else if (part == "korpus")                    body();
else if (part == "gitter1" && n_bays >= 1)    grid_insert(bays[0][0], bays[0][1]);
else if (part == "gitter2" && n_bays >= 2)    grid_insert(bays[1][0], bays[1][1]);
else if (part == "gitter3" && n_bays >= 3)    grid_insert(bays[2][0], bays[2][1]);
else if (part == "gitter4" && n_bays >= 4)    grid_insert(bays[3][0], bays[3][1]);
else if (part == "rueckwand")                 rear_wall();
else {  // montage (Vorschau der konfigurierten Belegung)
    body();
    for (i = [0 : n_bays - 1])
        translate([wall_t + i*(bay_inner_w + divider_t) + clearance,
                   wall_t + clearance, body_height - insert_h])
            grid_insert(bays[i][0], bays[i][1]);
    rear_wall();
}
