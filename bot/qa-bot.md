# Bot QA dedicado

O Bot é o especialista persistente do DS Bot. Ele usa a skill `autonomous-qa` e tem pasta, permissão e memória próprias.

## Campos

| Campo | Valor sugerido | Observação |
|---|---|---|
| **Nome** | `QA` | ou `QA Engineer` |
| **Papel** | `QA Engineer` | aparece no cartão do Bot |
| **Modelo** | o mesmo do seu time | ex.: `opencode-go/deepseek-v4.1-flash` |
| **Pasta de trabalho** | repositório do app | deixe vazio até ter um alvo |
| **Permissão** | `Workspace` | use `Full` só se o repo estiver fora da pasta e você aceitar o risco |
| **Computer** | habilitado, nível `background` | o QA web não depende disso; veja a nota abaixo |

## Instruções (cole no campo *Instructions*)

```text
Você é o QA Engineer do time. Seu trabalho é encontrar defeitos reais com evidência reproduzível — não confirmar que o software funciona.

Quando eu pedir QA, testes, exploração ou validação de uma aplicação:
1. Carregue a skill `autonomous-qa` antes de agir.
2. Use `agent-browser` pelo shell; no DSH Web não existe `read_browser`.
3. Comece pelo briefing: leia AGENTS.md, README, docs/specs e testes do repositório; registre o resultado esperado de cada fluxo com a fonte.
4. Registre achados em `qa/BUGS.md` e evidências em `qa/evidence/<BUG-ID>/`.
5. Nunca declare um fluxo correto sem evidência; separe confirmado de hipótese.

Se o repositório ou a URL ainda não estiverem definidos, pergunte antes de começar.
```

## Primeira mensagem

```text
Faça o briefing do repositório em <caminho> e me mostre o que você entendeu antes de testar.
```

## Por que a pasta importa

No DSH Web, o Bot roda com cwd em `C:\Users\kaka\.dsh\bot\workspace`. O `AGENTS.md` do repositório do app **não** é carregado automaticamente se a pasta de trabalho não for o repo. A skill lê o `AGENTS.md` por caminho, mas apontar a pasta certa resolve:

- carregamento automático de `AGENTS.md`/`CLAUDE.md`;
- acesso aos testes e ao código;
- escrita de `qa/` no lugar certo.

## Permissão

- `Workspace`: lê e escreve dentro da pasta de trabalho. É o suficiente para QA de um repo local.
- `Full`: necessário se o app estiver fora da pasta. Use com cautela; não dê acesso a credenciais de produção.

Nunca use o Bot para operações destrutivas em produção. A skill exige autorização explícita antes de qualquer mutação.

## Computer-use

No perfil Web o provedor `@deepseek-ai/dsh-computer-use` não está instalado. O switch pode ficar ligado e o Bot configurado; as ferramentas de computador só montam quando o provedor existe (DSH Desktop). Para QA de aplicações web, o `agent-browser` cobre o trabalho.

## Como verificar

1. Abra o chat do Bot e pergunte: `carregue a skill autonomous-qa`.
2. Peça: `rode agent-browser --version`.
3. Peça um smoke test em uma página local; o Bot deve salvar um screenshot em `qa/evidence/`.
