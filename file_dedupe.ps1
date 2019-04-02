$filesA = Get-ChildItem "E:\path"
$dedupefolder = "E:\path2"

for ($i=0; $i -lt $filesA.Count; $i++) {
$fileA = $filesA[$i].FullName
$k=0
for ($j=0; $j -lt $filesB.Count; $j++) {
$j=$j+$k
$fileB = $filesB[$j].FullName
if([math]::abs((Get-Item $fileA).Length - (Get-Item $fileB).Length) -lt 10000)
 {if((Get-FileHash $fileA).hash  -eq (Get-FileHash $fileB).hash){
  Move-Item $fileB "E:\!deleted"
  $filesB = Get-ChildItem $dedupefolder
  $k++
  break
  }
 }
 }
 }
