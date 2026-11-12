Charging stations for electric toothbrushes are device-specific, and off-the-shelf holders usually fit just **one** model in **one** layout. This holder is **fully configurable**: 1–4 bays, each one selectable for **Oral-B or Sonicare** and as a **stand or charging variant** – all via parameters, with the body growing automatically to match.

This lets you tailor the holder exactly to your household: a single Sonicare charging bay for the guest bathroom, an Oral-B pair with one charging and one stand slot, or the full row with four mixed bays for the family bathroom. Two people, two different brands, one stand for drying and a charging spot next to it? No problem – the layout is simply defined per bay.

**How it works.** The **body** is a rectangular tray with rounded R5 edges, a closed bottom and a thin, purely decorative **Voronoi relief** on the front and sides. It stands on four plug-in feet. The actual functional surfaces sit in **interchangeable inserts** that slide in from the back and are held by a tongue-and-groove joint (sliding-lid principle) – the insert does not lift out when you pull the brush off. A separate, vertically inserted **rear wall** locks the inserts in place and has a small cable hole for each bay.

**Insert types per bay:**
- **Charging** – opening for the loosely placed original charging station, which sits flush with the top surface (Oral-B: oval opening; Sonicare: D-shaped outline with a semicircular cable channel).
- **Stand** – central peg to put the brush on for drying (Oral-B: oval, tapered peg; Sonicare: round peg).
- **Tray** – fully closed plate, e.g. for brush heads or small items.
- **Cup** – tall cup with a Voronoi outer wall, fits into one bay.

Everything **comes apart without tools**: changing the layout later just means swapping an insert – not reprinting the whole holder. **No third-party models** were used; only the functional interface dimensions (charging openings, pegs, charging heights) were measured on reference parts so that the Oral-B and Sonicare stations and brushes fit.

**Profiles.** The included profiles cover the common layouts (e.g. Sonicare single, Oral-B single, charging + stand pairs, as well as combinations with tray and cup). Just pick the matching profile and print – or put together your own layout in the Customizer.

### Customize it yourself (Parametric Model Maker / Customizer)

Via **"Customize"** you can reconfigure the holder directly in the browser – no OpenSCAD installation needed:

1. **`part` (part selection)** – defines *what* is generated: `platte` prints all parts ready-arranged on one plate, `montage` shows the assembly preview, or a single part (`korpus`, `gitter1…4`, `rueckwand`, `fuss`, `ablage`, `becher` – the dropdown shows English and German names).
2. **`n_bays`** – number of bays (**1–4**). The body width is generated to match automatically.
3. **`bay1`…`bay4`** – type per bay. Options per bay: *Oral-B stand*, *Oral-B charging*, *Sonicare stand*, *Sonicare charging*, *tray* or *cup*. Only as many `bay` fields count as `n_bays` is set to.

A typical workflow: first set `n_bays`, then assign a type to each bay via `bay1…bayN`, generate the print plate with `part = platte` and slice it. To reprint a single insert (e.g. when switching a bay from stand to charging later), simply set `part` to the corresponding `gitterN`.

> Note: The Voronoi surface relief is precomputed for 4 bays and is only trimmed at the front for fewer bays – this is purely cosmetic and does not affect the fit.

---

I **welcome feedback and suggestions** – whether fit experiences after printing, requests for additional devices/variants, or ideas for further development. Feel free to leave a comment!
