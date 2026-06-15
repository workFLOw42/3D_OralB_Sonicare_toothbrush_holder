# Changelog

Versionshistorie des frei konfigurierbaren Zahnbürstenhalters. Format angelehnt an
[Keep a Changelog](https://keepachangelog.com/de/). Maße in mm.

## [2.0] – 2026-06-15 · Steck-System, flaches Relief, geschlossene Einsätze + Ablage

Umbau im Stil der Kabelbox v2. Stützenfreier, schlichterer Aufbau.

### Geändert
- **Voronoi-Relief flach** (rein optisch, ~Lagen-dünn): `relief_h` 1,4 → **0,4 mm**
  (Korpus + Rückwand); neuer `relief_insert_h` = **0,2 mm** (Einsätze).
- **Einsätze geschlossen** statt offenes Gitter: solide Platte (T-Profil für die
  Schiebeführung bleibt) mit **dünnem Voronoi-Relief oben**. Gilt **universal** für
  alle Einsatz-Typen (Ständer, Laden, Ablage). Ständer-Zapfen und Lade-Öffnungen
  bleiben funktional; bei „Laden" wird die Relief-Schicht über der Öffnung mitgeräumt.
- **Füße steckbar**: integrierte Füße entfallen; der Boden trägt **4 Sacklöcher**
  (Ø5,1, 2 mm tief), die Füße sind ein **separates Teil** (`foot.scad`, Zylinder Ø10
  × 5 mm + Zapfen Ø5 × 2 mm nach oben) und werden von unten eingesteckt. Kein nach
  unten zeigender Zapfen → stützenfrei.
- **Wände +1 mm** höher: `body_height` 24 → **25 mm** (Ladestationen bleiben über
  `pf = body_height − charger_h` bündig).

### Geändert · Geräte-Passung (Maße)
- **Sonicare-Ladeöffnung** 1 mm schmaler + 2 mm weniger tief: `son_charger_x` 40 → 39,
  `son_charger_y` 55 → 53.
- **Sonicare-Einsatz**: neue **halbrunde Kabelrinne** (5 mm breit × 2 mm hoch) auf der
  **Unterseite** am geraden D-Ende → Kabel liegt sauber nach hinten (`son_cable_w/h`).
- **Oral-B-Ladeöffnung** 1 mm schmaler + 1 mm weniger tief: `orb_charger_x` 42 → 41,
  `orb_charger_y` 55 → 54.

### Neu
- **Einsatz-Typ „Ablage"** (`tray`): komplett geschlossene Platte ohne Zapfen/Öffnung,
  je Fach wählbar (`bayN = "tray"`) und als eigenes Teil in der MakerWorld-Datei.
- **`gen_makerworld.py`**: erzeugt die MakerWorld-Einzeldatei reproduzierbar aus den
  Quellen. Customizer-Teile zusätzlich: `fuss` (Steck-Fuß) und `ablage`.
- `build.ps1` / `pack_3mf.py` bauen/packen jetzt auch die Füße.

## [1.2] – 2026-06-12 · Sonicare-Zapfen angepasst

### Geändert · Geräte-Passung (Maße)
- **Sonicare-Ständer-Zapfen** im Durchmesser auf **Ø5,5 mm** vergrößert
  (`son_peg_d` 5 → 5.5) und in der **Schafthöhe um 1,5 mm gekürzt** auf **8,5 mm**
  (`son_peg_h` 10 → 8.5). Betrifft den Sonicare-Ständer-Einsatz (`grid3.stl` in der
  Standard-Belegung).
- STL (`grid3`), 3MF und Vorschaubilder (`doc_iso`, `doc_top`) neu gebaut;
  MakerWorld-Einzeldatei gespiegelt.

---
## [1.1] – 2026-06-10 · Robuste hintere Eckpfosten + Geräte-Passung

### Geändert / Behoben
- **Rückwand-Halterung neu konstruiert** (Kabelbox-Stil): Die senkrechten Nuten sitzen
  jetzt in **zwei massiven hinteren Eckpfosten** statt in einer dünnen Seitenwand-Skin.
  Behebt den **Bruch der fragilen Nut-Anschläge** beim Entfernen der Stützstrukturen
  (Probedruck v1.0) – hinter der Nut steht jetzt **~5,7 mm Vollmaterial** (vorher 1,2 mm
  freistehender Steg). Modul `rear_stops()` entfällt.
- **Rückwand bündig**: Rückwand jetzt **10 mm tief** (`rear_wall_t`), schließt hinten
  **bündig mit den Pfosten** ab; **Feder vorn** (`rear_tongue_d`=4 mm) greift in die
  Pfosten-Nut. Voronoi-Relief läuft durchgehend über die Rückseite.
- **Gehäuse +6 mm tiefer in Y**: `body_depth` 78 → 79. Korpus außen **249,8 × 94,4 × 24 mm**
  (X unverändert). Fach-/Einsatz-Tiefe bleibt **78,7 mm**. Plattenlayout **249,8 × 196,6 mm**
  (< 256 × 256, Bambu X2D).
- **Parameter**: `rear_wall_t` 4 → 10, `rear_tongue_d`=4 neu; `rear_back_skin` entfällt.
- Voronoi-Seitenrelief neu erzeugt (Seitenflächen 78 → 84 mm). Alle STL/3MF neu gebaut;
  MakerWorld-Einzeldatei gespiegelt.

### Geändert · Geräte-Passung (Maße)
- **Sonicare-Ladeöffnung** an das reale Ladegerät angepasst: **40 × 55 mm**
  (vorher 51 × 63 mm), vorne voller **Halbkreis Ø40 mm**.
  `son_charger_x` 51 → 40, `son_charger_y` 63 → 55.
- **Sonicare-Ständer-Zapfen** auf **Ø5 mm** reduziert (`son_peg_d` 7 → 5).
- **Oral-B-Ladeöffnung** weitet sich jetzt **zur Unterseite hin im 45°-Winkel**
  auf (Einführtrichter; oben unverändert passgenau) – das Ladegerät lässt sich
  unten leichter einstellen. Neues Modul `charge_cut()` in `grid.scad`.
- STL `grid1/2/3`, 3MF und Vorschaubilder (`doc_iso`, `doc_top`, `assembly_back`)
  neu gebaut; MakerWorld-Einzeldatei gespiegelt.

---
## [1.0] – 2026-06-07 · Erste Veröffentlichung

Frei konfigurierbarer Halter für elektrische Zahnbürsten (Oral-B + Sonicare),
Eigenentwicklung in OpenSCAD + Python.

### Funktionen
- **Korpus**: rechteckige Wanne mit 1–4 Fächern, Voronoi-Relief auf Front + 2 Seiten,
  alle Außenkanten R5 gerundet, 4 Füße, geschlossener Boden. Seitenwände 5 mm dick.
- **Konfigurierbar**: `n_bays` (1–4) und je Fach ein Typ (`bay1..bay4`):
  Oral-B/Sonicare × Ständer/Laden. Belegung baut sich daraus; der Korpus skaliert
  automatisch in der Breite.
- **Einsätze (Feder & Nut, Schiebedeckel-Prinzip)**: seitliche Lippen an der
  Fach-Oberkante übergreifen die Einsatz-Oberkante (`rail_thick`=3, Überstand 2 mm).
  Einsatz wird **von hinten eingeschoben** und hebt sich beim Abziehen der Bürste
  **nicht** mehr mit. Front = Anschlag.
  - **Ständer**: Zapfen (Oral-B oval 8×9,6→7,5×9; Sonicare Ø7).
  - **Laden**: bündige Öffnung (Oral-B oval 42×55; Sonicare D-Kontur 51×63,
    **Bogen vorne**).
- **Separate Rückwand**: von oben senkrecht in **Nuten bündig in den Seitenwänden**
  + Boden-Nut eingeschoben; **Nut hinten geschlossen** → Rückwand sitzt **fest**.
  Folgt der R5-Gehäuserundung (oben/unten/hinten), trägt das Rückseiten-Voronoi-Relief
  und je Fach einen **nach unten offenen Kabel-Schlitz** (Stecker passt durch).
- **Montage**: Ladestation in den Lade-Einsatz legen → Einsätze (inkl. Station) von
  hinten einschieben → Rückwand von oben einschieben. Demontage umgekehrt.

### Maße (Standard 4 Fächer)
- Korpus außen 249,8 × 88,4 × 24 mm (+5 mm Füße), Fach innen 57 × 78 mm.
- Druckplatte aller Teile < 256 × 256 mm (Bambu X2D).

### Dateien / Toolchain
- Quelle (parametrisch): `params.scad` (Wahrheitsquelle) · `voronoi.scad` ·
  `voronoi_data.scad` (auto) · `body.scad` · `grid.scad` · `rear_wall.scad` ·
  `assembly.scad` (Vorschau).
- **MakerWorld**: `zahnbuersten_voronoi_makerworld.scad` – in sich geschlossene
  EIN-DATEI mit Customizer (Belegung + Teil-Auswahl). `part="platte"` legt alle
  Teile druckfertig auf eine X2D-Platte.
- Werkzeuge: `gen_voronoi.py` (scipy) → STL → `pack_3mf.py` → 3MF; `build.ps1`.
- Funktionale Maße aus Referenz-3MFs vermessen (durch die Geräte vorgegeben);
  siehe `MEASUREMENTS.md`. Geometrie ist Eigenentwicklung – kein Remix.

### Hinweis
- Das Voronoi-**Flächenrelief** ist für 4 Fächer vorberechnet; bei weniger Fächern
  wird es vorne nur beschnitten (rein optisch). Die **Gitter-Muster** in den Fächern
  sind unabhängig und immer korrekt.

---

## Vorab-Entwicklung (vor 1.0, 2026-06-06/07)
Kompakte Historie der Entwicklungsschritte:
- **Erstentwurf**: rechteckiger 4-Fach-Halter, Voronoi-Relief + Einsteckgitter.
- **Schnittstellen vermessen**: Sonicare D-Kontur 51×63 & bündiges Laden;
  Oral-B Ladeöffnung oval 42×55; Oral-B-Zapfen oval 8×9,6→7,5×9 (Mesh-Schnitt),
  Sonicare-Zapfen Ø7.
- **Form**: R5-Kantenrundung, 4 Füße, geschlossener Boden, Ständer-Zapfen.
- **Schiebehaltung**: Feder-&-Nut-Einsätze + separate, einschiebbare Rückwand
  (Nut bündig in den Seitenwänden, hinten geschlossen; unten offene Kabel-Schlitze).
- **Konfigurierbarkeit** + **MakerWorld-Einzeldatei** + **X2D-Plattenlayout**.
- Doku als Eigenentwicklung klargestellt (kein Remix/Redesign).
