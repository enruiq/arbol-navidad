$d = $PSScriptRoot
$t = [IO.File]::ReadAllText("$d\template.html")
$ot = [IO.File]::ReadAllText("$d\opentype.js")
$map = @{ titan='titan-one'; lilita='lilita-one'; chango='chango'; bowlby='bowlby-one' }
$parts = foreach ($k in $map.Keys) {
  $b = [Convert]::ToBase64String([IO.File]::ReadAllBytes("$d\$($map[$k])-latin-400-normal.woff"))
  "`"$k`":`"$b`""
}
$fonts = '{' + ($parts -join ',') + '}'
$pp = [IO.File]::ReadAllText("$d\paper.js")
$of = [IO.File]::ReadAllText("$d\offset.js")
$ec = [IO.File]::ReadAllText("$d\earcut.js")
$t = $t.Replace('/*EARCUT*/', $ec)
$t = $t.Replace('/*PAPER*/', $pp).Replace('/*OFFSET*/', $of)
$t = $t.Replace('/*OPENTYPE*/', $ot).Replace('/*FONTS*/', $fonts)
$av = 'data:image/jpeg;base64,' + [Convert]::ToBase64String([IO.File]::ReadAllBytes("$d\avatar.jpg"))
$t = $t.Replace('/*AVATAR*/', $av)
[IO.File]::WriteAllText("$d\..\index.html", $t, (New-Object Text.UTF8Encoding $false))
