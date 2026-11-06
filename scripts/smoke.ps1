# Smoke test do toolchain: abre uma página local, interage, verifica o resultado
# e salva um screenshot. Não precisa de aplicação alvo.
$ErrorActionPreference = 'Stop'

$repo      = Split-Path -Parent $PSScriptRoot
$fixture   = Join-Path $repo 'scripts\fixture.html'
$artifacts = Join-Path $repo 'scripts\.artifacts'
$session   = 'qa-smoke'

if (-not (Get-Command agent-browser -ErrorAction SilentlyContinue)) {
  throw 'agent-browser não encontrado. Instale com: npm i -g agent-browser; agent-browser install'
}
if (-not (Test-Path -LiteralPath $fixture)) {
  throw "Fixture não encontrada: $fixture"
}

New-Item -ItemType Directory -Force -Path $artifacts | Out-Null
$url = ([uri]$fixture).AbsoluteUri

Write-Host "1/5 abrindo $url"
agent-browser --session $session open $url | Out-Null
agent-browser --session $session wait --load domcontentloaded | Out-Null

Write-Host '2/5 verificando o título'
$title = (agent-browser --session $session eval 'document.title' 2>&1) -join "`n"
if ($title -notmatch 'dsh-qa smoke') {
  throw "Título inesperado: $title"
}

Write-Host '3/5 preenchendo e clicando'
agent-browser --session $session fill '#name' 'Kauan' | Out-Null
agent-browser --session $session click '#greet' | Out-Null

Write-Host '4/5 verificando o resultado'
$out = (agent-browser --session $session eval "document.querySelector('#out').textContent" 2>&1) -join "`n"
if ($out -notmatch 'Olá, Kauan') {
  throw "Resultado inesperado: $out"
}

Write-Host '5/5 salvando evidência'
$shot = Join-Path $artifacts 'smoke.png'
agent-browser --session $session screenshot --annotate $shot | Out-Null

$errors = (agent-browser --session $session errors 2>&1) -join "`n"
agent-browser --session $session close | Out-Null

if ($errors -match '\S' -and $errors -notmatch 'no (page )?errors|nenhum') {
  Write-Warning "O console reportou erros: $errors"
}

if (-not (Test-Path -LiteralPath $shot)) {
  throw "Screenshot não foi criado: $shot"
}

Write-Host ""
Write-Host "  Smoke test OK" -ForegroundColor Green
Write-Host "  Evidência: $shot" -ForegroundColor DarkGray
Write-Host ""
