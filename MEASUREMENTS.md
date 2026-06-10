# Herkunft der Maße (Provenance)

Dieser Halter ist eine **Eigenentwicklung** – die Geometrie ist vollständig
selbst konstruiert. Übernommen wurden nur die *funktionalen Schnittstellenmaße*
(Ladeöffnungen, Zapfen, Ladehöhen), die durch die Oral-B-/Sonicare-Geräte
physikalisch vorgegeben sind. Sie wurden aus Referenz-3MF-Dateien geometrisch
**vermessen, nicht geschätzt**. Diese Datei dokumentiert **Quelle, Methode und
Ergebnis** je Maß, damit alles nachvollziehbar/prüfbar ist.

## Referenzdateien (extern, nicht im Repo)
| Datei | Inhalt | genutzt für |
|---|---|---|
| `Ladestation_OralB_neu.3mf` | Referenzteil (Korpus + Gitter) | Oral-B Cavity-/Ladehöhe (~21 mm) |
| `Ladestation_OralB_Ladeloch.3mf` | „chargeur"-Gitter (Ladering) | Oral-B Ladeöffnung (oval) |
| `Ladestation_OralB_ständer.3mf` | „1b"-Ständergitter mit Zapfen | Oral-B Ständer-Zapfen |
| `Philips_Sonicare_Toothbrush_Holder_v2.3mf` | Sonicare-Ladestationshalter | Sonicare Ladestation (D-Kontur, Höhe) |
| `Ladestation_Aufsatz_Sonicare.3mf` | Sonicare-Ständergitter | Sonicare Ständer-Zapfen |

## Methoden
Alle Auswertungen mit **trimesh** (Mesh aus den `.model`-XML im 3MF gelesen) +
**scipy/numpy**:
- **BBox/Volumen**: direkte Mesh-Extents.
- **Aussparungen** (Becher/Recess): `mesh.voxelized(pitch).fill()` → 3D-Belegung;
  innere Leerregion je Schicht via `scipy.ndimage` (Label/Distanztransform).
- **Lochkonturen** (Ladeöffnungen): Oberflächen-Sampling → 2D-Belegungsraster →
  morphologisches Schließen (Lattice→Silhouette) → größte innere Leerregion.
- **Zapfenprofil**: Voxel-Schichten entlang der Zapfenachse; pro Höhe die
  zusammenhängende Voll-Strecke durch das Zentrum in X bzw. Z (Oval/Verjüngung).
Die Mess-Skripte und die Referenz-3MF sind **nicht Teil des Repos** (Fremdmodelle); Methodik und Ergebnisse oben dokumentieren alles Noetige.

---

## Ergebnisse

### Oral-B Ladehöhe / Cavity (aus `Ladestation_OralB_neu.3mf`)
- Referenzteil zum Kontext: 190 × 80 × 27 mm; 3 ovale Gitter (je ~65,7/56,1 × 74,6)
  pro Reihe. *(Nur als Vergleich – der hier entwickelte Korpus 249,8 × 88,4 × 24 ist eigenständig.)*
- Cavity-Tiefe (Fach) ≈ **21 mm** (Voxel-Analyse, Öffnung entlang der 27-mm-Achse)
  → entspricht der Oral-B-Ladestationshöhe (bündiger Abschluss).
- Übernommen: ovale Gitter-Grundfläche, modulares Stecksystem, Wandstärken-Größenordnung.

### Oral-B Ladeöffnung (aus `Ladestation_OralB_Ladeloch.3mf`, „chargeur"-Gitter)
- Gitter 56,1 × 3,0 × 74,6 mm (dünner Wabenring).
- Innere Öffnung (Lochkontur-Methode): **X ≈ 41,6 mm × Z ≈ 54,8 mm** → **oval ~42 × 55 mm**, Bandbreite ~7 mm.
- ⇒ `orb_charger_x = 42`, `orb_charger_y = 55` (Ellipse, nicht rund).
  > **v1.1-Anpassung:** Die Öffnung weitet sich im Modell **zur Unterseite hin im 45°-Winkel** auf (Einführtrichter; oben passgenau).

### Oral-B Ständer-Zapfen (aus `Ladestation_OralB_ständer.3mf`, object_16)
- Scheibe 65,7 × 16,0 × 74,6 mm (Wabenlattice); Scheibe Y −8…−4,5 (≈3,5 mm),
  zentrale Vollsäule (Zapfen) ragt Y −4,5…+8 heraus = **12,5 mm über Scheibe**.
- Methode: exakte Querschnitt-**Polygone** per `mesh.section` (nicht nur Sampling):

| Höhe ab Scheibe (mm) | X (kurz) | Y (lang) |
|---|---|---|
| 0 (Fuß) | 8,05 | 9,58 |
| ~4,5 (mitte) | 7,81 | 9,29 |
| ~12,5 (Spitze) | 7,5 | 9,0 |

- Form: **Ellipse** (Eck-Füllfaktor 0,13 ggü. Rechteck → keine gerundete
  Rechteckform nötig).
- ⇒ **ovaler, leicht verjüngender Zapfen**: Fuß ~8 × 9,6 → Spitze 7,5 × 9,0 mm,
  Höhe 12,5 (Langachse längs der Scheibe = Bay-Y).
  `orb_peg_base = [8, 9.6]`, `orb_peg_tip = [7.5, 9]`, `orb_peg_h = 12.5`.

### Sonicare Ladestation (aus `Philips_Sonicare_Toothbrush_Holder_v2.3mf`)
- Halterkörper (object_3) 125 × 25 × 65 mm, wasserdicht, Volumen 84 cm³ (große Aussparung, oben offen).
- Aussparung (Voxel-Analyse, öffnet entlang der 25-mm-Achse): Pocket-Querschnitt
  **63 × 51 mm**, **Tiefe ≈ 20 mm** (darunter ~5 mm Boden).
- ⇒ Sonicare-Ladestation **D-/Oval-Kontur 51 × 63 mm**, Höhe **20 mm**.
  `son_charger_x = 51`, `son_charger_y = 63`, `charger_h_son = 20`.
  Im Modell als **echte D-Kontur** (Rechteck + Halbkreis) umgesetzt.
  > **v1.1-Anpassung:** Modell-Öffnung an das reale Ladegerät angepasst und auf **40 × 55 mm** (Halbkreis vorne Ø40) verkleinert (`son_charger_x = 40`, `son_charger_y = 55`). Der Referenzwert 51 × 63 stammt aus dem Holder_v2-Mesh.

### Sonicare Ständer-Zapfen (aus `Ladestation_Aufsatz_Sonicare.3mf`, „centre 1B")
- Scheibe 56,1 × 11,0 × 74,6 mm; zentrale Vollsäule.
- Zapfenprofil (Querschnitt X×Z je Höhe): über die ganze Höhe **6,8 × 6,8 mm**
  (rund, keine Verjüngung); Fußbereich 15,6 × 11,6 (Sockel/Lattice).
- ⇒ **runder Zapfen Ø ≈ 7 mm** (Referenz).
  > **v1.1-Anpassung:** Zapfen im Modell auf **Ø5 mm** reduziert (`son_peg_d = 5`).

### Schiebedeckel-Mechanik (Referenz `Gridfinity_Box_with_Slide_Lid…3mf`)
Vorbild für die Feder-&-Nut-Schiebehaltung der Einsätze. Aus exakten
Querschnitt-Polygonen (`mesh.section`) der Box/Deckel-Teile gemessen:
- **Lippen-Überstand** (Box-Oberkante, nach innen) ≈ **2,0 mm**.
- **Feder/Tongue-Dicke** (Deckelrand unter der Lippe) ≈ **2,4 mm**.
- **Spiel** Feder↔Lippe ≈ **0,2 mm**; alle Kanten mit ~45°-Fasen (stützenfrei).
- ⇒ übernommen als `rail_overhang = 2`, `rail_thick = 2.4`, `rail_clear = 0.25`.

---

## Toleranzen / Hinweise
- Voxel-/Sampling-Auflösung 0,25–0,5 mm ⇒ Messunsicherheit ~±0,4 mm.
- Werte sind in `params.scad` zentral und einzeln feinjustierbar (z. B. nach
  einem Probedruck Spiel an Zapfen/Öffnungen um 0,2–0,5 mm anpassen).
- Die „Fuß/Sockel"-Zeilen in den Zapfentabellen (sehr breite Werte am Grund)
  stammen teils aus angrenzenden Lattice-Stegen und sind nicht Teil des
  eigentlichen Zapfenschafts.
