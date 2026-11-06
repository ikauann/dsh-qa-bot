# Relatório de bugs

Um relatório útil permite que outra pessoa **reproduza e verifique** cada achado sem falar com você.

## 1. Cabeçalho do `qa/BUGS.md`

```markdown
# Relatório de QA — <app>

- **Ambiente:** dev | staging | prod (somente leitura)
- **Build/commit:** <sha ou versão>
- **Data:** AAAA-MM-DD
- **Navegador:** <versão> · **Resolução:** <viewport>
- **Escopo:** <jornadas testadas>
- **Fora de escopo:** <o que não foi testado>

## Resumo
| Severidade | Abertos | Em progresso | Corrigidos | Verificados |
|---|---:|---:|---:|---:|
| Critical | | | | |
| High | | | | |
| Medium | | | | |
| Low | | | | |

## Cobertura
| Jornada | Frontend | Backend | Negativo | Evidência | Resultado |
|---|---|---|---|---|---|
```

## 2. Template de bug

```markdown
### BUG-001 — <título curto e específico>

- **Severidade:** Critical | High | Medium | Low
- **Categoria:** Frontend | Backend | API | Database | UX | Security
- **Status:** Open | In Progress | Fixed | Verified
- **Confiança:** Confirmado | Hipótese
- **Ambiente:** <URL, commit, navegador>
- **Frequência:** sempre | intermitente | <n> de <m> tentativas

**Passos para reprodução**
1. ...
2. ...
3. ...

**Resultado esperado**
<o que deveria acontecer>
**Fonte:** `spec: docs/...` | `teste: tests/...` | `contrato: openapi.yaml` | `premissa: ...`

**Resultado atual**
<o que aconteceu, com trecho de log/response>

**Evidência**
- `qa/evidence/BUG-001/before.png`
- `qa/evidence/BUG-001/console.log`
- `qa/evidence/BUG-001/response.json`

**Causa provável**
<confirmada ou hipótese> — `arquivo:linha`

**Arquivos potencialmente envolvidos**
- `src/...:linha`
```

## 3. Severidade

| Nível | Critério | Exemplos |
|---|---|---|
| **Critical** | Perda/corrupção de dados, bypass de autenticação/autorização, fluxo principal impossível sem workaround, exposição de dados | IDOR, login quebrado, pagamento em dobro |
| **High** | Fluxo principal quebrado com workaround, contrato de API violado, inconsistência grave de estado | Erro 500 em rota central, validação ausente em campo crítico |
| **Medium** | Fluxo secundário quebrado, validação incompleta, UI enganosa com workaround | Filtro que ignora um parâmetro, mensagem de erro errada |
| **Low** | Cosmético, copy, acessibilidade menor, UX sem impacto funcional | Alinhamento, placeholder, foco |

Na dúvida entre dois níveis, escolha o menor e registre o impacto. Severidade não é prioridade: prioridade é do produto.

## 4. Categorias

- **Frontend:** renderização, estado, eventos, navegação, responsivo.
- **Backend:** regra de negócio, processamento, jobs, integrações.
- **API:** contrato, status, payload, versionamento, erros.
- **Database:** schema, migration, índice, consistência, transação.
- **UX:** fluxo confuso, feedback ausente, acessibilidade, copy.
- **Security:** authn/authz, injeção, XSS/CSRF, exposição, rate limit.

## 5. Confiança

- **Confirmado:** reproduzido com passos + evidência + fonte do esperado.
- **Hipótese:** suspeita fundamentada, ainda sem reprodução ou sem fonte. Não conta como bug confirmado.

## 6. Ciclo de status

```text
Open → In Progress → Fixed → Verified
```

- **Fixed** exige o código alterado e o caso que falhava passando.
- **Verified** exige reexecutar o repro, os testes relacionados e a regressão, com evidência "depois".

## 7. Evidência

```text
qa/evidence/BUG-001/
├─ repro.md          # passos exatos e resultado
├─ before.png        # screenshot anotado
├─ after.png         # após a correção (Fixed/Verified)
├─ console.log       # erros do console
├─ response.json     # request/response redigidos
└─ trace.zip         # opcional: trace do Chrome
```

Regras:

- Redija tokens, cookies, senhas e dados pessoais antes de salvar.
- Prefira `screenshot --annotate` para evidência visual.
- Guarde o arquivo completo em disco; no relatório, cite só o trecho relevante.
- Nunca commite `auth-state.json`, `.env` ou vídeos grandes.

## 8. Agrupamento e deduplicação

- Um bug por **causa raiz**, não por tela.
- Se o mesmo defeito aparece em várias rotas, registre um bug e liste as rotas afetadas.
- Bugs relacionados: referencie (`Relacionado: BUG-003`).
- Não abra bug para "melhoria" sem combinar com o usuário; use a seção de observações.

## 9. Exemplo preenchido

```markdown
### BUG-007 — Cupom expirado é aceito no checkout

- **Severidade:** High
- **Categoria:** Backend
- **Status:** Open
- **Confiança:** Confirmado
- **Ambiente:** dev, commit a1b2c3d, Chrome 157
- **Frequência:** sempre

**Passos**
1. Faça login com a conta de teste.
2. Adicione qualquer item ao carrinho.
3. Aplique o cupom `EXPIRED10`.

**Esperado:** rejeitar com 422 e mensagem "cupom expirado".
**Fonte:** `spec: docs/checkout.md §3.2`

**Atual:** pedido é criado com 10% de desconto.

**Evidência**
- `qa/evidence/BUG-007/before.png`
- `qa/evidence/BUG-007/response.json`

**Causa provável (hipótese):** validação de data só no cliente — `src/checkout/coupon.ts:42`.
```
