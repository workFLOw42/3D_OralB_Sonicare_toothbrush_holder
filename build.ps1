# Baut alle Teile reproduzierbar: Voronoi-Daten -> STL -> 3MF -> Vorschau
$ErrorActionPreference = "Stop"
$osc = "C:\Program Files\OpenSCAD\openscad.exe"
$dir = $PSScriptRoot

Write-Host "1/4 Voronoi-Daten erzeugen..."
python "$dir\gen_voronoi.py"

Write-Host "2/4 Korpus rendern..."
& $osc -o "$dir\body.stl" "$dir\body.scad"

Write-Host "3/4 Gitter + Rueckwand + Fuss rendern..."
for ($i = 0; $i -lt 4; $i++) {
    & $osc -D bay_index=$i -o "$dir\grid$i.stl" "$dir\grid.scad"
}
& $osc -D part_id=4 -o "$dir\grid4.stl" "$dir\grid.scad"   # Ablage (geschlossen)
& $osc -D part_id=5 -o "$dir\grid5.stl" "$dir\grid.scad"   # Becher
& $osc -o "$dir\rearwall.stl" "$dir\rear_wall.scad"
& $osc -o "$dir\foot.stl"     "$dir\foot.scad"

Write-Host "4/4 3MF packen + Vorschau..."
python "$dir\pack_3mf.py"
& $osc -o "$dir\assembly_iso.png" --imgsize 950,650 --viewall --autocenter `
    --colorscheme Tomorrow --camera=0,0,0,62,0,22,0 "$dir\assembly.scad"

Write-Host "Fertig. Ausgaben: body.stl, grid0..3.stl, grid4(Ablage), grid5(Becher), foot.stl, 3MF"
