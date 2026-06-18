Ladestationen für elektrische Zahnbürsten sind gerätespezifisch, und fertige Halter passen meist nur zu **einem** Modell in **einer** Anordnung. Dieser Halter ist **frei konfigurierbar**: 1–4 Fächer, je Fach wählbar für **Oral-B oder Sonicare** und als **Ständer- oder Lade-Variante** – alles über Parameter, der Korpus wächst automatisch mit.

So lässt sich der Halter exakt auf den eigenen Haushalt zuschneiden: ein einzelnes Sonicare-Ladefach fürs Gäste-WC, ein Oral-B-Paar aus Lade- und Ständerplatz, oder die volle Reihe mit vier gemischten Fächern fürs Familienbad. Zwei Personen, zwei verschiedene Marken, ein Ständer zum Trocknen und ein Ladeplatz daneben? Kein Problem – die Belegung wird einfach pro Fach festgelegt.

**Funktionsweise.** Der **Korpus** ist eine rechteckige Wanne mit abgerundeten R5-Kanten, geschlossenem Boden und einem dünnen, rein optischen **Voronoi-Relief** auf Front und Seiten. Er steht auf vier steckbaren Füßen. Die eigentlichen Funktionsflächen stecken in **austauschbaren Einsätzen**, die von hinten eingeschoben und per Feder-&-Nut gehalten werden (Schiebedeckel-Prinzip) – beim Abziehen der Bürste hebt sich der Einsatz nicht mit. Eine separate, senkrecht eingeschobene **Rückwand** sichert die Einsätze und trägt je Fach ein kleines Kabelloch.

**Einsatz-Typen pro Fach:**
- **Laden** – Öffnung für die lose eingestellte Original-Ladestation, die oben flächenbündig abschließt (Oral-B: ovale Öffnung, Sonicare: D-Kontur mit halbrunder Kabelrinne).
- **Ständer** – zentraler Zapfen zum Aufstecken der Bürste zum Trocknen (Oral-B: ovaler, sich verjüngender Zapfen; Sonicare: runder Zapfen).
- **Ablage** – komplett geschlossene Platte, z. B. für Aufsteckbürsten oder Kleinkram.
- **Becher** – hoher Becher mit Voronoi-Außenwand, passt in ein Fach.

Alles ist **werkzeuglos zerlegbar**: Belegung später ändern heißt nur, einen Einsatz zu tauschen – nicht den ganzen Halter neu zu drucken. Es wurden **keine fremden Modelle** übernommen; lediglich die funktionalen Schnittstellenmaße (Ladeöffnungen, Zapfen, Ladehöhen) wurden an Referenzteilen vermessen, damit die Stationen und Bürsten von Oral-B und Sonicare passen.

**Profile.** Die mitgelieferten Profile decken die gängigen Anordnungen ab (z. B. Sonicare einzeln, Oral-B einzeln, Lade- + Ständer-Paare, sowie Kombinationen mit Ablage und Becher). Einfach das passende Profil wählen und drucken – oder im Customizer eine eigene Anordnung zusammenstellen.

### Selbst anpassen (Parametric Model Maker / Customizer)

Über **„Customize / Personalisieren"** lässt sich der Halter direkt im Browser umkonfigurieren – ohne OpenSCAD-Installation:

1. **`part` (Teil-Auswahl)** – legt fest, *was* erzeugt wird: `platte` druckt alle Teile fertig angeordnet auf einer Platte, `montage` zeigt die Zusammenbau-Vorschau, oder ein Einzelteil (`korpus`, `gitter1…4`, `rueckwand`, `fuss`, `ablage`, `becher`).
2. **`n_bays`** – Anzahl der Fächer (**1–4**). Der Korpus wird in der Breite automatisch passend erzeugt.
3. **`bay1`…`bay4`** – Typ je Fach. Auswahl pro Fach: *Oral-B Ständer*, *Oral-B Laden*, *Sonicare Ständer*, *Sonicare Laden*, *Ablage* oder *Becher*. Es zählen nur so viele `bay`-Felder wie `n_bays` gesetzt ist.

Ein typischer Ablauf: erst `n_bays` festlegen, dann jedem Fach über `bay1…bayN` einen Typ zuweisen, mit `part = platte` die Druckplatte erzeugen und slicen. Zum Nachdrucken eines einzelnen Einsatzes (z. B. wenn man später von Ständer auf Laden wechselt) einfach `part` auf das entsprechende `gitterN` stellen.

> Hinweis: Das Voronoi-Flächenrelief ist für 4 Fächer vorberechnet und wird bei weniger Fächern vorne nur beschnitten – das ist rein optisch und ändert nichts an der Passform.

---

Ich **freue mich über Feedback und Vorschläge** – ob Passungs-Erfahrungen nach dem Druck, Wünsche für weitere Geräte/Varianten oder Ideen zur Weiterentwicklung. Schreibt mir gern in die Kommentare!
