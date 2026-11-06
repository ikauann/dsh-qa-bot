# Briefing & oráculo

Objetivo: transformar o repositório em um **contrato explícito** do que o app é e do que "correto" significa — antes de testar. Sem isso, o QA testa sintaxe, não comportamento.

## 1. Ordem de leitura (barata → cara)

| Ordem | O que ler | Pergunta que responde |
|---|---|---|
| 1 | `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING` | Como trabalhar neste repo? Comandos, convenções, restrições. |
| 2 | `README*`, `docs/`, `specs/`, ADRs | O que é o app? Para quem? Quais são as regras? |
| 3 | `package.json`, `pyproject.toml`, `composer.json`, `go.mod`, `*.csproj`, `Makefile` | Como subir, testar, migrar? |
| 4 | `docker-compose*`, `.env.example`, `compose.yaml` | Serviços, portas, banco, variáveis. |
| 5 | Rotas/controllers, models, migrations, validações | Contrato real da API e do banco. |
| 6 | `tests/`, `e2e/`, `__tests__/` | O que já é garantido e como testar. |
| 7 | `MEMORY.md`, `CHANGELOG`, issues, `git log` | Decisões, incidentes, o que mudou recentemente. |

Pare quando tiver o suficiente para escrever o briefing. Não leia o repositório inteiro.

## 2. Hierarquia de fontes

Quando duas fontes divergirem, registre o conflito no briefing e siga esta ordem:

1. **Critério de aceite explícito** (spec, ticket, contrato, ADR).
2. **Teste automatizado existente** (é spec executável).
3. **Contrato de API** (OpenAPI/JSON Schema).
4. **Comportamento consistente no resto do app** (derivação — vira premissa).
5. **Opinião do usuário** (só depois de perguntar).

`AGENTS.md` é orientação **operacional**, não especificação de produto. `MEMORY.md` é histórico, não verdade atual.

## 3. O que o briefing precisa conter

- **Propósito:** uma frase sobre o problema que o app resolve.
- **Personas/papéis:** quem usa e o que cada um pode fazer.
- **Jornadas principais:** 3 a 7 fluxos que, se quebrarem, quebram o produto.
- **Resultado esperado por jornada:** o que deve acontecer, com a fonte.
- **Critérios de aceite:** lista verificável, com `spec:`/`teste:`/`contrato:`.
- **Regras de negócio e invariantes:** limites, cálculos, permissões, estados.
- **Fora de escopo:** o que o QA não vai testar nesta rodada.
- **Premissas:** o que foi assumido por falta de fonte.
- **Perguntas em aberto:** o que precisa da decisão do usuário.
- **Mapa de fontes:** `arquivo:linha` do que embasou cada conclusão.

## 4. Modelo `qa/briefing.md`

```markdown
# Briefing — <nome do app>

## Propósito
<uma frase>

## Personas e permissões
| Papel | Pode | Não pode |
|---|---|---|

## Jornadas principais
| # | Jornada | Resultado esperado | Fonte | Prioridade |
|---|---|---|---|---|
| J1 | Login | ... | spec: docs/auth.md §2 | P0 |

## Critérios de aceite
- [ ] ... — fonte: `teste: tests/auth.spec.ts:12`

## Regras de negócio e invariantes
- ...

## Fora de escopo
- ...

## Premissas
- ...

## Perguntas em aberto
- ...

## Mapa de fontes
- `README.md:1` — ...
- `src/routes/auth.ts:40` — ...
```

## 5. Quando não existe spec

1. Derive o esperado do comportamento **consistente** do resto do app.
2. Apoie-se em testes existentes e nos padrões do framework.
3. Marque como `premissa:` no briefing e no bug.
4. Pergunte ao usuário apenas o que for ambíguo e material.

Nunca transforme uma premissa em bug confirmado sem validação.

## 6. Sinais de que o briefing está fraco

- Descreve telas, não jornadas.
- Não diz o que deveria acontecer em caso de erro.
- Não tem nenhuma fonte (`spec:`, `teste:`, `contrato:`).
- Não lista o que está fora de escopo.
- Não separa fato de suposição.
