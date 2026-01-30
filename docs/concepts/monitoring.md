# Мониторинг и метрики

Подсистема интеграции предоставляет встроенную поддержку экспорта метрик в формате Prometheus для мониторинга состояния очередей, производительности и обнаружения проблем.

## Архитектура мониторинга

```
┌───────────────────────────────────────────────────────────────────┐
│                         1С:Предприятие                            │
│  ┌────────────────┐    ┌──────────────────┐    ┌───────────────┐  │
│  │ Регламентное   │───▶│ Справочник       │───▶│ Регистр       │  │
│  │ задание        │    │ пэмМетрики       │    │ пэмСостояние  │  │
│  │ пэм_ВыполнитьР │    │ (алгоритмы)      │    │ Метрик        │  │
│  │ асчетМетрик    │    └──────────────────┘    └───────┬───────┘  │
│  └────────────────┘                                    │          │
│                                                        ▼          │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │           HTTP-сервис /prometheus/polling                  │   │
│  └────────────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────────|──┘
                                                                 │
                    ┌────────────────────────────────────────────┼──┐
                    │                                            ▼  │
                    │  ┌──────────────┐    ┌──────────────────────┐ │
                    │  │  Prometheus  │───▶│      Grafana         │ │
                    │  │  (scrape)    │    │   (dashboards)       │ │
                    │  └──────────────┘    └──────────────────────┘ │
                    │                    Мониторинг                  │
                    └────────────────────────────────────────────────┘
```

## Способы экспорта метрик

### Pull-модель (рекомендуется)

HTTP-сервис для Prometheus scraping:

```
GET /prometheus/polling
Authorization: Basic <credentials>
```

**Пример ответа:**

```prometheus
# HELP pde_queue_length Количество сообщений в очередях
# TYPE pde_queue_length gauge
pde_queue_length{queue="incoming"} 42
pde_queue_length{queue="outgoing"} 156
pde_queue_length{queue="distribution"} 23

# HELP pde_error_count Количество сообщений с ошибками
# TYPE pde_error_count gauge
pde_error_count{flow_name="orders_export",error_type="formation_error",direction="outgoing"} 3
pde_error_count{flow_name="prices_import",error_type="processing_error",direction="incoming"} 1
```

### Push-модель (Pushgateway)

Для сред без прямого доступа к 1С можно настроить отправку метрик на Pushgateway:

| Константа | Описание |
|-----------|----------|
| `пэмИспользоватьPushgateway` | Включить push-режим |
| `пэмАдресСервераPushgateway` | Адрес сервера (например, `pushgateway.local`) |
| `пэмПортСервераPushgateway` | Порт (по умолчанию `9091`) |
| `пэмПутьНаСервереPushgateway` | Путь (по умолчанию `/metrics/job/1c_integration`) |

## Справочник метрик

### Метрики очередей

#### pde_queue_length

**Тип:** Gauge  
**Описание:** Текущий размер очередей сообщений (количество ожидающих обработки)

| Лейбл | Описание | Значения |
|-------|----------|----------|
| `queue` | Тип очереди | `incoming`, `outgoing`, `distribution` |

**Алерты:**
```yaml
- alert: QueueBacklog
  expr: pde_queue_length > 1000
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Очередь {{ $labels.queue }} растёт"
```

---

#### pde_oldest_pending_age_seconds

**Тип:** Gauge  
**Описание:** Возраст старейшего необработанного сообщения в секундах. Индикатор «застрявших» сообщений.

| Лейбл | Описание | Значения |
|-------|----------|----------|
| `queue` | Тип очереди | `incoming`, `outgoing`, `distribution` |

**Алерты:**
```yaml
- alert: StuckMessages
  expr: pde_oldest_pending_age_seconds > 3600
  for: 5m
  labels:
    severity: critical
  annotations:
    summary: "Сообщения застряли в очереди {{ $labels.queue }}"
```

---

### Метрики ошибок

#### pde_error_count

**Тип:** Gauge  
**Описание:** Количество сообщений в состоянии ошибки

| Лейбл | Описание | Значения |
|-------|----------|----------|
| `flow_name` | Наименование потока данных | Строка |
| `error_type` | Тип ошибки | `formation_error`, `send_error`, `processing_error` |
| `direction` | Направление | `incoming`, `outgoing` |

**Типы ошибок:**
- `formation_error` — ошибка при формировании (исполнении обработчика)
- `send_error` — ошибка отправки подписчику
- `processing_error` — ошибка обработки входящего сообщения

---

#### pde_retry_count

**Тип:** Gauge  
**Описание:** Количество сообщений с повторными попытками обработки

| Лейбл | Описание | Значения |
|-------|----------|----------|
| `flow_name` | Наименование потока данных | Строка |
| `direction` | Направление | `incoming`, `outgoing` |

::: tip Применение
Высокие значения могут указывать на нестабильные внешние сервисы или ошибки в логике обработчиков.
:::

---

### Метрики производительности

#### pde_formation_duration_seconds

**Тип:** Gauge  
**Описание:** Время выполнения обработчика формирования сообщений

| Лейбл | Описание | Значения |
|-------|----------|----------|
| `flow_name` | Наименование потока данных | Строка |
| `aggregation` | Тип агрегации | `avg`, `max` |

**Период агрегации:** последние 5 минут

---

#### pde_send_duration_seconds

**Тип:** Gauge  
**Описание:** Время отправки сообщений подписчикам (включая сетевые задержки)

| Лейбл | Описание | Значения |
|-------|----------|----------|
| `flow_name` | Наименование потока данных | Строка |
| `aggregation` | Тип агрегации | `avg`, `max` |

**Период агрегации:** последние 5 минут

---

#### pde_incoming_duration_seconds

**Тип:** Gauge  
**Описание:** Время обработки входящих сообщений

| Лейбл | Описание | Значения |
|-------|----------|----------|
| `flow_name` | Наименование потока данных | Строка |
| `aggregation` | Тип агрегации | `avg`, `max` |

**Период агрегации:** последние 5 минут

---

### Метрики пропускной способности

#### pde_messages_per_minute

**Тип:** Gauge  
**Описание:** Количество обработанных сообщений за последнюю минуту

| Лейбл | Описание | Значения |
|-------|----------|----------|
| `flow_name` | Наименование потока данных | Строка |
| `operation` | Тип операции | `formation`, `send`, `incoming` |
| `status` | Результат | `success`, `error` |

**Пример PromQL:**
```promql
# Общая пропускная способность
sum(pde_messages_per_minute{status="success"}) by (operation)

# Error rate по потокам
pde_messages_per_minute{status="error"} / 
(pde_messages_per_minute{status="error"} + pde_messages_per_minute{status="success"})
```

---

### Служебные метрики

#### pde_last_refresh

**Тип:** Gauge  
**Описание:** Unix timestamp последнего расчёта метрик (epoch seconds)

**Применение:** Мониторинг работоспособности самой системы сбора метрик

---

#### pde_scrape_duration

**Тип:** Gauge  
**Описание:** Время расчёта каждой метрики в миллисекундах

| Лейбл | Описание |
|-------|----------|
| `label` | Код метрики |

## Настройка сбора метрик

### Регламентное задание

Метрики рассчитываются регламентным заданием `пэмВыполнитьРасчетМетрик`:

| Параметр | Рекомендуемое значение |
|----------|------------------------|
| Расписание | Каждые 30-60 секунд |
| Многопоточность | Включить (`пэмМногопоточныйРасчетМетрик = Истина`) |

### Роли

| Роль | Назначение |
|------|------------|
| `пэмПолучениеМетрик` | Доступ к HTTP-сервису `/prometheus/polling` |
| `пэмНастройкаМетрик` | Настройка справочника метрик и констант |

### Добавление пользовательских метрик

Метрики хранятся в справочнике `пэмМетрики`. Для добавления новой метрики:

1. Создайте макет `CommonTemplate` с алгоритмом расчёта
2. Добавьте элемент справочника с настройками:
   - **Код** — имя метрики в Prometheus (например, `my_custom_metric`)
   - **Тип метрики** — `Counter` или `Gauge`
   - **Алгоритм** — ссылка на макет

**Формат алгоритма:**

```bsl
// Результат должен быть в переменной ТаблицаЗначений
// Колонки: label1, label2, ..., value (число)

ТаблицаЗначений = Новый ТаблицаЗначений;
ТаблицаЗначений.Колонки.Добавить("my_label", Новый ОписаниеТипов("Строка"));
ТаблицаЗначений.Колонки.Добавить("value", Новый ОписаниеТипов("Число"));

Запрос = Новый Запрос;
Запрос.Текст = "...";
ТаблицаЗначений = Запрос.Выполнить().Выгрузить();
```

## Интеграция с Grafana

### Prometheus scrape config

```yaml
scrape_configs:
  - job_name: '1c_integration'
    scrape_interval: 30s
    scrape_timeout: 10s
    metrics_path: /integration_base/hs/prometheus/polling
    basic_auth:
      username: prometheus_user
      password: secret
    static_configs:
      - targets: ['1c-server.local:80']
        labels:
          instance: 'prod-erp'
```

### Рекомендуемые панели Grafana

| Панель | Метрики | Тип визуализации |
|--------|---------|------------------|
| Размер очередей | `pde_queue_length` | Time series / Stat |
| Ошибки по потокам | `pde_error_count` | Bar chart |
| Пропускная способность | `pde_messages_per_minute` | Time series |
| Время обработки | `pde_*_duration_seconds` | Heatmap / Time series |
| Застрявшие сообщения | `pde_oldest_pending_age_seconds` | Gauge / Alert list |
| Повторные попытки | `pde_retry_count` | Stat / Table |

### Пример дашборда

```json
{
  "title": "1C Integration Subsystem",
  "panels": [
    {
      "title": "Queue Length",
      "targets": [
        { "expr": "pde_queue_length", "legendFormat": "{{ queue }}" }
      ]
    },
    {
      "title": "Messages/min",
      "targets": [
        { "expr": "sum(pde_messages_per_minute{status=\"success\"}) by (operation)" }
      ]
    },
    {
      "title": "Error Rate",
      "targets": [
        { "expr": "sum(pde_error_count) by (error_type)" }
      ]
    }
  ]
}
```

## Рекомендации по алертам

### Критические

```yaml
groups:
  - name: integration_critical
    rules:
      - alert: IntegrationQueueOverflow
        expr: pde_queue_length{queue="outgoing"} > 5000
        for: 10m
        labels:
          severity: critical
        annotations:
          summary: "Очередь исходящих переполнена"
          
      - alert: IntegrationStuckMessages
        expr: pde_oldest_pending_age_seconds > 7200
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Сообщения не обрабатываются более 2 часов"
```

### Предупреждения

```yaml
      - alert: IntegrationHighErrorRate
        expr: sum(pde_error_count) > 100
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Высокий уровень ошибок интеграции"
          
      - alert: IntegrationSlowProcessing
        expr: pde_formation_duration_seconds{aggregation="avg"} > 10
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Медленная обработка в потоке {{ $labels.flow_name }}"
```

## Диагностика через журнал регистрации

Помимо метрик, подсистема пишет события в журнал регистрации:

| Событие | Описание |
|---------|----------|
| `ПодсистемаИнтеграции.ОчередьИсходящихСообщений` | Формирование и отправка |
| `ПодсистемаИнтеграции.ОбработкаВходящихСообщений` | Обработка входящих |
| `ПодсистемаИнтеграции.МенеджерПотоковОбработки*` | Работа менеджеров потоков |

## Связанные материалы

- [Очереди сообщений](/concepts/message-queues) — как работают очереди
- [Многопоточность](/concepts/multithreading) — параллельная обработка
- [Обработка входящих](/guide/incoming-http-processing) — настройка входящих потоков
