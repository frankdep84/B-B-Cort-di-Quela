# Scarica in img\ tutte le foto di Cort di Quela da beb.it e aggiorna index.html.
# Uso (dalla cartella del repo):
#   powershell -ExecutionPolicy Bypass -File scripts\scarica-foto.ps1
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
$cdn = 'https://dhqbz5vfue3y3.cloudfront.net'
$ua  = 'Mozilla/5.0'
New-Item -ItemType Directory -Force img | Out-Null

$html  = (Invoke-WebRequest -UseBasicParsing -UserAgent $ua 'https://beb.it/cortdiquela/it/').Content
$paths = [regex]::Matches($html, 'fotobbit/39867/\d/[A-Za-z0-9_.-]+\.jpg') | ForEach-Object { $_.Value } | Sort-Object -Unique
Write-Host "Trovate $($paths.Count) foto"

foreach ($p in $paths) {
  $f = Join-Path 'img' ([IO.Path]::GetFileName($p))
  if ($p -match '/5/') { $f = Join-Path 'img' ('cover-' + [IO.Path]::GetFileName($p)) }
  if (-not (Test-Path $f)) {
    Invoke-WebRequest -UseBasicParsing -UserAgent $ua "$cdn/$p" -OutFile $f
    Write-Host "ok $f"
  }
}

Invoke-WebRequest -UseBasicParsing -UserAgent $ua 'https://www.topbnb.it/img/banner/topbb-quadrato-1.png' -OutFile 'img\topbnb.png'
$cdnEsc = [regex]::Escape("$cdn/fotobbit/39867/5/39867.jpg")
# Punta index.html alle copie locali (og:image e JSON-LD restano assoluti)
$pattern = [regex]::Escape("$cdn/fotobbit/39867/") + '[45]/'
$lines = Get-Content index.html -Encoding UTF8 | ForEach-Object {
  if ($_ -match 'og:image|@context') { $_ } else { ($_ -replace $cdnEsc, 'img/cover-39867.jpg') -replace $pattern, 'img/' }
}
$lines = $lines | ForEach-Object { $_ -replace [regex]::Escape('https://www.topbnb.it/img/banner/topbb-quadrato-1.png'), 'img/topbnb.png' }
[IO.File]::WriteAllLines((Resolve-Path index.html), $lines, (New-Object Text.UTF8Encoding($false)))
Write-Host 'Fatto. Controlla la cartella img\'
