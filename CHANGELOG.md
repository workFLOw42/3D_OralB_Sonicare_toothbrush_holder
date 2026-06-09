# Changelog

Versionshistorie des frei konfigurierbaren Zahnbürstenhalters. Format angelehnt an
[Keep a Changelog](https://keepachangelog.com/de/). Maße in mm.

## [1.1] – 2026-06-09 · Robuste hintere Eckpfosten

### Geändert / Behoben
- **Rückwand-Halterung neu konstruiert** (Kabelbox-Stil): Die senkrechten Nuten sitzen
  jetzt in **zwei massiven hinteren Eckpfosten** statt in einer dünnen Seitenwand-Skin.
  Behebt den **Bruch der fragilen Nut-Anschläge** beim Entfernen der Stützstrukturen
  (Probedruck v1.0) – hinter der Nut steht jetzt **~5,7 mm Vollmaterial** (vorher 1,2 mm
  freistehender Steg). Modul `rear_stops()` entfällt.
- **Gehäuse +6 mm tiefer in Y**: `body_depth` 78 → 79, neue Pfostentiefe `rear_post_d`=10.
  Korpus außen **249,8 × 94,4 × 24 mm** (X unverändert). Fach-/Einsatz-Tiefe bleibt
  **78,7 mm** (Ladestationen behalten ihren Platz). Plattenlayout **249,8 × 190,6 mm**
  (< 256 × 256, Bambu X2D).
- **Parameter**: `rear_post_d` neu (⟳ – Seitenrelief wird größer); `rear_back_skin` entfällt.
- Voronoi-Seitenrelief neu erzeugt (Seitenflächen 78 → 84 mm). Alle STL/3MF neu gebaut;
  MakerWorld-Einzeldatei gespiegelt.

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
