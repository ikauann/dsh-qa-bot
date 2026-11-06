# Reconhecimento por stack

Objetivo: descobrir **como subir, testar e inspecionar** o app sem adivinhar. Use `glob` e `grep` antes de `read`; leia só o necessário.

## 1. Checklist genérico

- [ ] Comando de instalação e de subida (dev/prod).
- [ ] Portas e URLs de frontend, API e banco.
- [ ] Variáveis de ambiente (`.env.example`, `docker-compose`).
- [ ] Autenticação: login local, OAuth, token, seed de usuários.
- [ ] Banco: engine, migrations, seed, como consultar com segurança.
- [ ] Testes: comando, framework, cobertura, testes que já falham.
- [ ] Rotas/controllers e contratos (OpenAPI, tRPC, GraphQL).
- [ ] Jobs/filas/integrações externas e seus mocks.
- [ ] Feature flags e estados especiais.

## 2. Node / TypeScript

| Onde olhar | O que extrair |
|---|---|
| `package.json` (`scripts`, `dependencies`) | `dev`, `build`, `test`, `lint`, `db:*` |
| `next.config.*`, `vite.config.*`, `nuxt.config.*` | portas, proxy, rotas |
| `src/app/**`, `pages/**`, `src/routes/**` | rotas e layouts |
| `prisma/schema.prisma`, `drizzle/`, `migrations/` | modelos e migrations |
| `playwright.config.*`, `vitest.config.*`, `jest.config.*` | como rodar e2e/unit |
| `Dockerfile`, `docker-compose*` | serviços e portas |

Comandos comuns (confirme no repo): `npm ci`, `npm run dev`, `npm test`, `npx playwright test`, `npx prisma migrate dev`.

## 3. Python

| Onde olhar | O que extrair |
|---|---|
| `pyproject.toml`, `requirements*.txt`, `Pipfile` | deps e scripts |
| `manage.py`, `alembic.ini`, `migrations/` | Django/Flask/FastAPI, migrations |
| `app/main.py`, `app/routers/`, `urls.py` | rotas |
| `pytest.ini`, `tox.ini`, `conftest.py` | testes e fixtures |
| `docker-compose*`, `.env.example` | serviços |

Comandos comuns: `pip install -r requirements.txt`, `uvicorn app.main:app --reload`, `python manage.py runserver`, `pytest -q`.

## 4. PHP / Laravel

| Onde olhar | O que extrair |
|---|---|
| `composer.json` | scripts e deps |
| `routes/web.php`, `routes/api.php` | rotas |
| `app/Models/`, `database/migrations/` | modelos e schema |
| `phpunit.xml`, `tests/` | testes |
| `.env.example` | banco, fila, mail |

Comandos comuns: `composer install`, `php artisan serve`, `php artisan migrate --seed`, `php artisan test`.

## 5. Java / Spring

| Onde olhar | O que extrair |
|---|---|
| `pom.xml`, `build.gradle` | deps e plugins |
| `src/main/resources/application*.yml` | portas, datasource |
| `src/main/java/**/controller/` | rotas |
| `src/test/` | testes |
| `docker-compose*` | banco e serviços |

Comandos comuns: `./mvnw spring-boot:run`, `./mvnw test`, `./gradlew bootRun`, `./gradlew test`.

## 6. .NET

| Onde olhar | O que extrair |
|---|---|
| `*.sln`, `*.csproj` | projetos e target framework |
| `Program.cs`, `Startup.cs` | pipeline e rotas |
| `appsettings*.json` | conexão e features |
| `tests/` | xUnit/NUnit |

Comandos comuns: `dotnet restore`, `dotnet run`, `dotnet test`.

## 7. Docker / Compose

```bash
docker compose config          # valida e mostra serviços
docker compose up -d           # sobe em background
docker compose ps              # portas e saúde
docker compose logs -f <svc>   # logs
```

Antes de derrubar qualquer coisa: confirme que o ambiente é local/dev e que não há dados que você não pode perder.

## 8. Banco de dados

- Prefira **somente leitura**: `SELECT`, `EXPLAIN`, contagens.
- Nunca rode `DROP`, `TRUNCATE`, `DELETE` sem autorização.
- Em dev, use transação com rollback para testar mutações: `BEGIN; ...; ROLLBACK;`.
- Confirme a consistência: o dado que a UI mostra existe no banco e veio da API?

## 9. Autenticação e autorização

- Descubra como criar/obter um usuário de teste (seed, fixture, endpoint de dev).
- Verifique **horizontal** (outro usuário acessa o recurso alheio — IDOR) e **vertical** (usuário comum acessa rota de admin).
- Teste token expirado, ausente, inválido e de outro papel.
- Nunca use credenciais reais de produção em teste.

## 10. Segurança do próprio recon

- Não execute scripts desconhecidos do repositório sem ler.
- Não rode migrations em banco compartilhado sem confirmar.
- Não suba serviço que ocupa porta em uso; descubra a porta antes.
- Não imprima `.env`; leia apenas as chaves necessárias.
