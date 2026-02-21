# Copilot Instructions for Integration Subsystem (Подсистема интеграции)

## Project Overview

This is a **1C:Enterprise 8.3** integration subsystem that handles message queues for outgoing/incoming data flows with validation (OpenAPI 3.0), multi-threading, and monitoring (Prometheus).

## Architecture

### Core Data Flow
```
ИсходныеДанные (Source Data) → ПотокДанных (Data Flow) → Подписчик (Subscriber)
                                    ↓
                         Обработчик (Handler) executes custom BSL code
```

### Key Objects by Layer
| Layer | Objects | Purpose |
|-------|---------|---------|
| **Catalogs** | `инт_ПотокиДанных`, `инт_Подписчики`, `инт_Схемы`, `инт_Эндпоинты` | Configuration entities |
| **Registers** | `инт_ОчередьИсходящихСообщений`, `инт_ОчередьВходящихСообщений`, `инт_ТекущийСтатус*` | Message queues and status tracking |
| **Common Modules** | `инт_*` prefix (e.g., `инт_ВалидаторПакетов`, `инт_ОтправкаИсходящихСообщений`) | Business logic |

### Subscriber Types
HTTP arbitrary, Integration Subsystem (cross-database), RabbitMQ, JRPC 2.0, Kafka

## Development Workflow

### Initial Setup
```batch
# Clone and configure
git clone <repo>
copy env.json.example env.json
prepare.cmd          # Creates database in build/ib, loads YAXUNIT extension
```

### Daily Workflow (Git-flow based)
```batch
git checkout -b feature/xxx develop
update.cmd           # MANDATORY: Sync DB with branch config (prevents phantom changes)
# ... develop ...
decompile.bat        # Export config changes to src/cf
git commit -m "..."
```

### TDD Development Cycle (Red-Green-Refactor)

Iterative loop until the feature is complete:

```
┌─ 1. Составить план (спецификация / задача)
│
│  ┌──────────────── inner loop ────────────────┐
│  │ 2. Написать / дополнить тесты              │
│  │    → src/cfe/YAXUnit/CommonModules/        │
│  │                                            │
│  │ 3. Написать / изменить код                 │
│  │    → src/cf/  (конфигурация)               │
│  │                                            │
│  │ 4. Обновить базу данных                    │
│  │    > update.cmd                            │
│  │                                            │
│  │ 5. Запустить тесты                         │
│  │    > test.cmd                              │
│  │                                            │
│  │ 6. Проверить результат                     │
│  │    → build/test-reports/ (Allure XML)      │
│  │    → exit code: 0 = OK, иначе — провал    │
│  │                                            │
│  │ если тесты красные ──► повтор с шага 2/3   │
│  └────────────────────────────────────────────┘
│
└─ 7. Финализация
      > decompile.bat   # выгрузить и тесты, и код в src/
      > git add . && git commit
```

#### Шаг 4 — `update.cmd`: что происходит

| Этап | Команда | Результат |
|------|---------|-----------|
| 1 | `vrunner update-dev --src src/cf --disable-support` | Загрузка конфигурации из `src/cf` → `build/ib` |
| 2 | `vrunner compileexttocfe --src src/cfe/YAXUNIT --out build/YAXUNIT.cfe` | Сборка расширения тестов в `.cfe` |
| 3 | `vrunner run ... ЗагрузитьРасширениеВРежимеПредприятия.epf` | Загрузка расширения YAXUNIT в базу |
| 4 | `vrunner run ... ЗапуститьОбновлениеИнформационнойБазы` | Обновление БД в режиме Предприятия |

> **Важно:** `update.cmd` обновляет **и** основную конфигурацию, **и** расширение с тестами.
> Это значит, что после изменения _любых_ исходников (код или тесты) достаточно одного вызова `update.cmd`.

#### Шаг 5 — `test.cmd`: что происходит

| Этап | Команда | Результат |
|------|---------|-----------|
| 1 | Генерация `build/yaxunit-config.json` | Конфиг с абсолютными путями для YAXUnit |
| 2 | `vrunner run --command "RunUnitTests=..."` | Запуск 1С:Предприятие с параметром YAXUnit |
| 3 | Чтение `build/test-reports/exitCode.txt` | Код возврата: `0` — все тесты пройдены |

Отчёты в формате Allure сохраняются в `build/test-reports/`.

#### Практические рекомендации

- **Не открывайте Конфигуратор** одновременно с `update.cmd` — файл БД блокируется.
- Если нужно отлаживать тест вручную, используйте VS Code task **"Run current feature in 1C:Enterprise + WAIT"** — он не закрывает 1С после прогона.
- При добавлении **нового** общего модуля тестов: добавьте его в `src/cfe/YAXUnit/`, а не в основную конфигурацию.
- После окончания работы **всегда** выполняйте `decompile.bat` — он выгрузит и `src/cf`, и `src/cfe/YAXUnit`.

### Key Commands
| Command | Purpose |
|---------|---------|
| `prepare.cmd` | Initial DB setup from `src/cf` + YAXUNIT extension |
| `update.cmd` | Update existing DB: config + YAXUNIT extension + DB update |
| `decompile.bat` | Export configuration to `src/cf` and extension to `src/cfe/YAXUnit` |
| `build.cmd` | Compile to `build/1cv8.cf` |
| `test.cmd` | Run YAXUNIT tests, reports to `build/test-reports/` |

## Testing with YAXUNIT

Tests are located in extension `src/cfe/YAXUnit/CommonModules/`. Naming convention:
- `ОМ_*` — tests for Common Modules (e.g., `ОМ_инт_ВалидаторПакетов`)
- `РС_*_ММ` — tests for Information Registers Manager Module
- `СПР_*_ММ` — tests for Catalogs Manager Module

### Test Structure Pattern
```bsl
Процедура ИсполняемыеСценарии() Экспорт
    ЮТТесты.УдалениеТестовыхДанных().ВТранзакции()
        .ДобавитьТестовыйНабор("НазваниеНабора")
            .ДобавитьТест("ИмяТеста")
            .ДобавитьТест("ТестСПараметрами").СПараметрами("value1");
КонецПроцедуры

Процедура ИмяТеста() Экспорт
    // Arrange
    ИсходныеДанные = ГенераторТестовыхДанных.демо_Документ();
    
    // Act + Assert using fluent API
    ЮТест.ОжидаетЧто(Результат).НеРавно(Неопределено);
    ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.инт_*").СодержитЗаписи(Предикат);
КонецПроцедуры
```

### Test Data Generation
Use `ГенераторТестовыхДанных` module for creating test fixtures:
- `ГенераторТестовыхДанных.ПотокДанныхИсходящий()` / `ПотокДанныхВходящий()`
- `ГенераторТестовыхДанных.демо_Документ()`

### Running Tests
Configure in `tests/uaxunit_config.json`. Launch parameter: `RunUnitTests=<path>\tests\uaxunit_config.json`

## Code Conventions

### Module Regions (strict order)
```bsl
#Область ПрограммныйИнтерфейс      // Public API
#Область СлужебныйПрограммныйИнтерфейс  // Internal API (used by subsystem)
#Область СлужебныеПроцедурыИФункции     // Private implementation
```

### Naming Prefixes
- `инт_` — Integration subsystem core objects
- `пэм` — Prometheus metrics objects
- `ИТКВ_` — Developer console toolkit (ancillary)

### Validation via OpenAPI 3.0
```bsl
// Validate data against schema
Ошибки = инт_ВалидаторПакетов.Валидировать(МодельДанных, "ИмяСхемы", СпецификацияJSON);
```
Schemas stored in `инт_Схемы` catalog, test fixtures in `tests/fixtures/schema.json`.

### Message Registration Pattern
```bsl
// Register message for outgoing flow
ИдентификаторСообщения = РегистрыСведений.инт_ОчередьИсходящихСообщений.ЗарегистрироватьСообщение(
    ИсходныеДанные,      // Source object reference or FixedStructure
    ПотокДанных,         // CatalogRef.инт_ПотокиДанных
    РегистрироватьДубль  // Optional: skip duplicates by hash
);
```

## Tooling

- **vrunner** (vanessa-runner) — build automation, configured in `tools/JSON/vrunner.json`
- **precommit4onec** — git hooks for code quality
- **BSL Language Server** — linting (directives like `// BSLLS:Typo-off` disable specific rules)
- **Platform version**: 8.3.24.1548

## File Structure
```
src/cf/           # Main configuration source (decompiled XML)
src/cfe/YAXUnit/  # Test extension with YAXUNIT framework
build/ib/         # Development database
tools/JSON/       # vrunner, vanessaBdd, vanessaTdd configs
tests/fixtures/   # Test data (OpenAPI schemas, etc.)
features/         # Vanessa BDD feature files
```
