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

### Key Commands
| Command | Purpose |
|---------|---------|
| `prepare.cmd` | Initial DB setup from `src/cf` |
| `update.cmd` | Update existing DB with config changes + YAXUNIT |
| `decompile.bat` | Export configuration to `src/cf` (and `src/cfe/YAXUnit`) |
| `build.cmd` | Compile to `build/1cv8.cf` |
| `test.cmd` | Run Vanessa BDD tests |

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
