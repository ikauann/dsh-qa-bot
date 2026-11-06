# Arquitetura

## Três artefatos, um procedimento

O modo é dividido em três camadas porque o DeepSeek Harness e o DS Bot têm superfícies diferentes:

| Camada | Artefato | Alcance | Por que existe |
|---|---|---|---|
| Núcleo | skill `autonomous-qa` | toda sessão com o preset `standard` e todo Bot do ds-bot | é o único artefato que atravessa as duas superfícies |
| Casca | preset `qa` | sessões Web/Desktop criadas com ele | dá nome, persona e um seletor de modo; não alcança Bots |
| Especialista | Bot `QA` | DS Bot | pasta, permissão, memória e instruções próprias |

## Por que a skill é o núcleo

O preset `standard` monta `dsh-skill-filesystem` com as raízes padrão, incluindo `<DSH_HOME>/skills` (rank 400). Qualquer `SKILL.md` colocado ali aparece no catálogo de toda sessão que use o preset `standard` — e os Bots do ds-bot são criados exatamente com esse preset.

```text
~/.dsh/skills/autonomous-qa/SKILL.md
        │
        ├─► sessão Web (preset standard ou qa)
        ├─► sessão Desktop
        └─► Bot do ds-bot (preset standard)
```

O catálogo é montado no início da sessão e atualizado quando a raiz monitorada muda. Uma sessão já aberta pode receber o catálogo novo; uma sessão nova sempre recebe.

## Por que o preset não resolve os Bots

Bots do ds-bot são criados com `agentPreset: 'standard'` (ver `roster.js` do ds-bot). Não há seletor de preset por Bot. Portanto:

- o preset `qa` vale para sessões Web/Desktop;
- o Bot usa a skill `autonomous-qa` + as instruções do Bot.

Isso não é uma limitação do repositório: é como o ds-bot foi desenhado. O preset continua útil para quem trabalha direto no DSH.

## Por que não MCP

MCP serve para expor ferramentas e serviços externos a um agente. Aqui não há serviço externo novo:

- navegador → `agent-browser` (CLI já instalada);
- API → `curl`/`Invoke-RestMethod` + testes do projeto;
- código → ferramentas de filesystem do DSH;
- evidência → arquivos em `qa/evidence/`.

Um servidor MCP só adicionaria processo, configuração e superfície de ataque sem cobrir nada que já não esteja coberto.

## Por que não "capability" do ds-bot

O ds-bot tem uma tela de **Capabilities** para MCP servers, skills e packs compartilhados. Uma skill salva ali:

- fica no `state.json` do time, não no Git;
- duplica o conteúdo que já está em `~/.dsh/skills`;
- não é versionada nem revisada em PR.

A skill em disco é a fonte de verdade. O Bot a vê pelo catálogo global; não é preciso cadastrá-la de novo.

## Fluxo de evidência

```text
qa/context.md      → ambiente, URL, escopo, credenciais redigidas
qa/briefing.md     → o que é o app + resultado esperado + fonte
qa/plan.md         → matriz de cobertura
qa/BUGS.md         → relatório (confirmado × hipótese)
qa/evidence/<ID>/  → screenshot, log, response, trace
```

Regra de ouro: **nenhum bug confirmado sem repro e evidência; nenhum "esperado" sem fonte**.

## Modelo de segurança

- Produção é somente leitura; mutação exige autorização explícita.
- Credenciais ficam em `.env.local`/segredos, nunca no relatório.
- `auth-state.json`, `.env` e vídeos são ignorados pelo Git.
- O Bot deve rodar com a menor permissão que funcione: `Workspace` + pasta do app é preferível a `Full`.
- O `agent-browser` usa sessão isolada (`--session qa-<app>`); não reutiliza o perfil pessoal do Chrome por padrão.

## Limites conhecidos

- **computer-use:** o provedor `@deepseek-ai/dsh-computer-use` não está instalado no perfil Web; o bundle oficial está `unsupported-platform`. A aba pode aparecer, mas as ferramentas só montam quando o provedor existe (DSH Desktop).
- **preset por Bot:** não existe; use instruções do Bot.
- **corpo da skill:** mantenha `SKILL.md` e cada referência abaixo de 8 KB; acima disso o pruner do preset `standard` corta o resultado da ferramenta.
- **catálogo:** uma sessão já aberta pode precisar de um novo turno para ver a skill; sessões novas veem na hora.

## Pontos de extensão

- **Conhecimento por projeto:** coloque um `.dsh/skills/<app>/SKILL.md` no repositório do app para rotas, contas e fluxos específicos. Ele é descoberto pelo mesmo `skill-filesystem`.
- **Testes persistentes:** Playwright Test (ou o framework já existente) para transformar os cenários de maior valor em regressão.
- **QA agendado:** uma tarefa `schedule_create` em staging que roda a skill e publica o relatório.
- **Times:** um grupo do ds-bot com admin + Bot QA + Bot de backend, usando `group_goal` para campanhas longas.
