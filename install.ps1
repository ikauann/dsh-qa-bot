[CmdletBinding()]
param(
  [string]$DshHome = $(if ($env:DSH_HOME) { $env:DSH_HOME } else { Join-Path $HOME '.dsh' })
)

$ErrorActionPreference = 'Stop'

$repo   = $PSScriptRoot
$source = Join-Path $repo 'skills\autonomous-qa'
$target = Join-Path $DshHome 'skills\autonomous-qa'

if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md'))) {
  throw "Skill não encontrada em $source. Rode este script na raiz do repositório dsh-qa-bot."
}

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
if (Test-Path -LiteralPath $target) {
  Write-Host "Substituindo instalação existente em $target" -ForegroundColor Yellow
  Remove-Item -LiteralPath $target -Recurse -Force
}
Copy-Item -LiteralPath $source -Destination $target -Recurse -Force

if (-not (Test-Path -LiteralPath (Join-Path $target 'SKILL.md'))) {
  throw "A cópia falhou: $target\SKILL.md não existe."
}

Write-Host ""
Write-Host "  Skill instalada" -ForegroundColor Green
Write-Host "  $target" -ForegroundColor DarkGray
Write-Host ""

if (-not (Get-Command agent-browser -ErrorAction SilentlyContinue)) {
  Write-Warning 'agent-browser não encontrado. Instale com: npm i -g agent-browser; agent-browser install'
} else {
  Write-Host "  agent-browser: $((agent-browser --version) -join ' ')" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "  Próximo passo — instale o preset (uma vez):" -ForegroundColor Cyan
Write-Host "    Peça ao DSH: instale o bundle $(Join-Path $repo 'preset')"
Write-Host "    Depois crie uma sessão e escolha 'Autonomous QA Engineer'."
Write-Host ""
Write-Host "  Para o Bot do ds-bot, veja bot/qa-bot.md." -ForegroundColor Cyan
Write-Host ""
