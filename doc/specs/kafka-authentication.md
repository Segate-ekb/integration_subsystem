# Спецификация: Аутентификация Kafka

## Обзор

Реализация поддержки аутентификации при подключении к брокерам Apache Kafka через внешнюю компоненту SimpleKafka1C (librdkafka).

Документация компоненты: https://github.com/NuclearAPK/Simple-Kafka_Adapter

## Поддерживаемые протоколы безопасности

Все параметры устанавливаются через `Компонента.УстановитьПараметр(ИмяПараметра, ЗначениеПараметра)` до вызова `ИнициализироватьПродюсера`/`ИнициализироватьКонсьюмера`.

Полный список: https://github.com/confluentinc/librdkafka/blob/master/CONFIGURATION.md

### 1. PLAINTEXT (без аутентификации)
- `security.protocol = plaintext` (по умолчанию)
- Тип авторизации эндпоинта: **Анонимный**
- Параметры: не устанавливаются

### 2. SASL/PLAIN
- `security.protocol = sasl_ssl`
- `sasl.mechanism = PLAIN`
- `sasl.username`, `sasl.password`
- Тип авторизации эндпоинта: **Basic** или **ApiKey**

### 3. SASL/SCRAM-SHA-512
- `security.protocol = sasl_ssl`
- `sasl.mechanism = SCRAM-SHA-512`
- `sasl.username`, `sasl.password`
- Тип авторизации эндпоинта: **Digest**

### 4. SSL (mTLS — клиентские сертификаты)
- `security.protocol = ssl`
- `ssl.certificate.location` — путь к файлу клиентского сертификата
- `ssl.key.location` — путь к файлу приватного ключа клиента
- `ssl.key.password` — пароль приватного ключа (строка)
- `ssl.ca.location` — путь к файлу корневого сертификата CA
- Тип авторизации эндпоинта: **Tls**

> **Примечание:** В безопасном хранилище хранятся **двоичные данные** сертификатов/ключей (тип `ДвоичныеДанные`), а librdkafka принимает только пути к файлам. Поэтому при установке параметров двоичные данные записываются во временные файлы в `КаталогВременныхФайлов()/kafka_certs/`, а путь к файлу передаётся в компоненту.

### 5. SASL/OAUTHBEARER (OIDC)
- `security.protocol = sasl_ssl`
- `sasl.mechanism = OAUTHBEARER`
- `sasl.oauthbearer.method = oidc`
- `sasl.oauthbearer.client.id`, `sasl.oauthbearer.client.secret`
- `sasl.oauthbearer.token.endpoint.url`
- `sasl.oauthbearer.scope` (опционально)
- Тип авторизации эндпоинта: **Bearer**

## Маппинг типов авторизации эндпоинта → параметры Kafka

| Тип авторизации | security.protocol | sasl.mechanism | Учётные данные из хранилища |
|---|---|---|---|
| Анонимный | plaintext (по умолч.) | — | — |
| Basic | sasl_ssl | PLAIN | `Basic_Пользователь` → `sasl.username`, `Basic_Пароль` → `sasl.password` |
| Digest | sasl_ssl | SCRAM-SHA-512 | `Digest_Пользователь` → `sasl.username`, `Digest_Пароль` → `sasl.password` |
| ApiKey | sasl_ssl | PLAIN | `ApiKey_ИмяЗаголовка` → `sasl.username`, `ApiKey_Значение` → `sasl.password` |
| Tls | ssl | — | `Tls_Сертификат` (ДвоичныеДанные → файл) → `ssl.certificate.location`, `Tls_ПарольСертификата` → `ssl.key.password` |
| Bearer | sasl_ssl | OAUTHBEARER | OIDC: `Bearer_Токен` → `sasl.oauthbearer.client.id` |

## Дополнительные ключи безопасного хранилища

Для Kafka-специфичных SSL-параметров используются дополнительные ключи безопасного хранилища эндпоинта:

| Ключ | Тип данных | Параметр librdkafka | Применение |
|---|---|---|---|
| `Kafka_СертификатCA` | ДвоичныеДанные → файл | `ssl.ca.location` | Все SSL/SASL_SSL протоколы |
| `Kafka_КлючСертификата` | ДвоичныеДанные → файл | `ssl.key.location` | Tls (mTLS) |
| `Kafka_OAuthClientSecret` | Строка | `sasl.oauthbearer.client.secret` | Bearer (OIDC) |
| `Kafka_OAuthTokenEndpoint` | Строка | `sasl.oauthbearer.token.endpoint.url` | Bearer (OIDC) |
| `Kafka_OAuthScope` | Строка | `sasl.oauthbearer.scope` | Bearer (OIDC), опционально |

## API

### Новый публичный метод `инт_РаботаСКафка.УстановитьПараметрыАвторизации`

```bsl
// Устанавливает параметры авторизации Kafka на экземпляр компоненты.
// Должен вызываться ПОСЛЕ создания компоненты и ПЕРЕД инициализацией продюсера/консьюмера.
//
// Параметры:
//  Компонента - AddIn - Экземпляр внешней компоненты simpleKafka1C
//  Эндпоинт - СправочникСсылка.инт_Эндпоинты - Эндпоинт с настроенной авторизацией
//
Процедура УстановитьПараметрыАвторизации(Компонента, Эндпоинт) Экспорт
```

### Обновление существующих методов

Во все публичные методы `инт_РаботаСКафка`, а также `инт_КонсьюмерОчередейСлужебный.СоздатьКонсьюмер` добавляется необязательный параметр `Эндпоинт = Неопределено`. При передаче — автоматически устанавливаются параметры авторизации.

## Затронутые модули

1. **инт_РаботаСКафка** — новый метод + интеграция во все публичные методы
2. **инт_КонсьюмерОчередейСлужебный** — интеграция в `СоздатьКонсьюмер`, `ОтправитьВDLQ`
3. **инт_ПодписчикиKafka (ManagerModule)** — передача `Эндпоинт` в методы отправки
