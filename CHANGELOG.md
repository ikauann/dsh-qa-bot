# Changelog

Todas as mudanças notáveis deste projeto são documentadas aqui.

O formato segue [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) e o projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [0.1.0] — 2026-11-06

### Adicionado

- Skill `autonomous-qa` com o fluxo completo: contrato, briefing e oráculo, plano de cobertura, exploratório com `agent-browser`, validação de API/backend, relatório de bugs, correção e testes persistentes.
- Referências sob demanda: `briefing.md`, `bug-report.md` e `recon.md`.
- Preset `Autonomous QA Engineer` (`preset-qa`) como bundle local do DeepSeek Harness.
- Guia do Bot QA dedicado em `bot/qa-bot.md`.
- Instaladores `install.ps1` (Windows) e `install.sh` (macOS/Linux).
- Smoke test do toolchain (`scripts/smoke.ps1`) com fixture local, sem aplicação alvo.
- Banner e documentação de arquitetura.

### Notas

- A skill é descoberta em `~/.dsh/skills/autonomous-qa` pelo preset `standard`; funciona em sessões DSH e em Bots do ds-bot.
- O preset vale apenas para sessões novas criadas com ele; Bots do ds-bot continuam no preset `standard`.
- `computer-use` não é dependência: o QA web usa `agent-browser`.
