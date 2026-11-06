#!/usr/bin/env bash
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dsh_home="${DSH_HOME:-$HOME/.dsh}"
source_dir="$here/skills/autonomous-qa"
target="$dsh_home/skills/autonomous-qa"

if [[ ! -f "$source_dir/SKILL.md" ]]; then
  echo "Skill não encontrada em $source_dir" >&2
  echo "Rode este script na raiz do repositório dsh-qa-bot." >&2
  exit 1
fi

mkdir -p "$(dirname "$target")"
if [[ -d "$target" ]]; then
  echo "Substituindo instalação existente em $target"
  rm -rf "$target"
fi
cp -R "$source_dir" "$target"

if [[ ! -f "$target/SKILL.md" ]]; then
  echo "A cópia falhou: $target/SKILL.md não existe." >&2
  exit 1
fi

echo ""
echo "  Skill instalada"
echo "  $target"
echo ""

if command -v agent-browser >/dev/null 2>&1; then
  echo "  agent-browser: $(agent-browser --version)"
else
  echo "  AVISO: agent-browser não encontrado. npm i -g agent-browser && agent-browser install" >&2
fi

echo ""
echo "  Próximo passo — instale o preset (uma vez):"
echo "    Peça ao DSH: instale o bundle $here/preset"
echo "    Depois crie uma sessão e escolha 'Autonomous QA Engineer'."
echo ""
echo "  Para o Bot do ds-bot, veja bot/qa-bot.md."
echo ""
