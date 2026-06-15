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

// 4 Fuß-/Sackloch-Positionen (gemeinsame Wahrheitsquelle für Boden + Füße).
// WICHTIG: hintere Füße NICHT bei outer_d-m setzen — dort liegt der Rückwand-
// Schacht + die Boden-Nut (kein Vollmaterial -> Sackloch waere durchgaengig und
// der Zapfen kollidierte mit der Rueckwand). Daher knapp VOR die Rückwand (yr).
function foot_pts() = let (m = foot_inset + foot_r, yr = rear_wall_y0 - foot_r - 2)
    [[m, m], [outer_w - m, m], [m, yr], [outer_w - m, yr]];

// Rückwand füllt die Pfostenzone bündig; ihre Feder greift vorn in die Pfosten-Nut.
rear_wall_y0 = outer_d - rear_wall_t;                // Vorderkante der Rückwand (Y) = wall_t + body_depth
insert_depth = rear_wall_y0 - rear_clear - wall_t;   // Einsatz-Tiefe (Front..Rückwand)

function charger_h(fn, mk) =
    (fn != "charge") ? 0 : (mk == "orb" ? charger_h_orb : charger_h_son);

$fn = 32;