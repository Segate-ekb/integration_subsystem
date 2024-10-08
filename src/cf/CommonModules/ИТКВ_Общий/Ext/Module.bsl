﻿#Область ПрограммныйИнтерфейс

// Получает код языка программирования
//
// Возвращаемое значение:
//   Строка - код языка программирования
//
Функция КодЯзыкаПрограммирования() Экспорт
	
	ОбщиеНастройки = ИТКВ_Настройки.Загрузить();
	
	Результат = ОбщиеНастройки["ЯзыкПрограммирования"];
	Если ЗначениеЗаполнено(Результат) Тогда
		Возврат Результат;
	КонецЕсли;
		
	Результат = КодЯзыкаПрограммированияКонфигурации();
	
	Возврат Результат;
	
КонецФункции

Функция КодЯзыкаПрограммированияКонфигурации() Экспорт
	
	Если ВариантВстроенногоЯзыкаРусский() Тогда
		Результат = ИТКВ_ОбщийКлиентСервер.КодЯзыкаРусский();
	Иначе
		Результат = ИТКВ_ОбщийКлиентСервер.КодЯзыкаАнглийский();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Выполнить экспортную процедуру
//
// Параметры:
//  ИмяМетода  - Строка - имя экспортной процедуры в формате
//                       <имя объекта>.<имя процедуры>, где <имя объекта> - это общий модуль
//  Параметры  - Массив - параметры передаются в экспортную процедуру в порядке расположения элементов массива.
//
Процедура ВыполнитьМетод(Знач ИмяМетода, Знач Параметры = Неопределено, БезопасныйРежим = Истина) Экспорт
	
	СписокПараметров = Новый Массив;
	Для Счетчик = 0 По Параметры.ВГраница() Цикл
		СписокПараметров.Добавить(СтрШаблон("Параметры[%1]", Счетчик));
	КонецЦикла;
	
	Если БезопасныйРежим Тогда
		УстановитьБезопасныйРежим(Истина);
	КонецЕсли;
	
	// BSLLS:ExecuteExternalCodeInCommonModule-off
	Выполнить ИмяМетода + "(" + СтрСоединить(СписокПараметров, ", ") + ")";
	// BSLLS:ExecuteExternalCodeInCommonModule-on
	
КонецПроцедуры

// Выполняет произвольный алгоритм на встроенном языке 1С:Предприятия с заданным контекстом
//
// Параметры:
//  АлгоритмРаботыСКонтекстом  - Строка - Алгоритм (работы с контекстом) на встроенном языке 1С:Предприятия.
//  Алгоритм  - Строка - Алгоритм на встроенном языке 1С:Предприятия.
//  Контекст  - Структура - Параметры контекста
//  БезопасныйРежим  - Булево - Безопасный режим
//
// Возвращаемое значение:
//   Строка - Текст ошибки
//
Функция ВыполнитьСКонтекстом(АлгоритмРаботыСКонтекстом, Алгоритм, Контекст, БезопасныйРежим = Ложь) Экспорт
	
	ТекстОшибки = "";
	// BSLLS:ExecuteExternalCodeInCommonModule-off
	Выполнить АлгоритмРаботыСКонтекстом;
	// BSLLS:ExecuteExternalCodeInCommonModule-on
	
	Возврат ТекстОшибки;

КонецФункции

// Вычисляет результат выполнения выражения
//
// Параметры:
//  Алгоритм  - Строка - алгоритм на встроенном языке 1С:Предприятия.
//
// Возвращаемое значение:
//   Произвольный - Результат вычисления выражения
//
Функция ВычислитьРезультатВыражениеВБезопасномРежиме(Алгоритм) Экспорт
	
	Результат = Неопределено;
	Result = Неопределено;
	
	УстановитьБезопасныйРежим(Истина);
	// BSLLS:ExecuteExternalCodeInCommonModule-off
	Выполнить Алгоритм;
	// BSLLS:ExecuteExternalCodeInCommonModule-on
	
	Если КодЯзыкаПрограммирования() = ИТКВ_ОбщийКлиентСервер.КодЯзыкаАнглийский() Тогда
		Результат = Result;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Получает ссылку по внутреннему идентификатору в формате SQL - Битой ссылки
//
// Параметры:
//  UID  - Строка - UID в формате (слитно)
//  Тип  - Тип - Тип
//
// Возвращаемое значение:
//   Булево - Истина, ссылочный тип
//
Функция СсылкаПоВнутреннемуUID(UID, Тип) Экспорт
	
	Если Не ИТКВ_ТипыКлиентСервер.ЭтоСсылочный(Тип) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПустаяСсылка = Новый (Тип);
	ТекстСсылкиВнутр = СтрЗаменить(ЗначениеВСтрокуВнутр(ПустаяСсылка), ИТКВ_Строки.ПустойUID(), UID);
	
	Попытка
		
		Результат = ЗначениеИзСтрокиВнутр(ТекстСсылкиВнутр);
		
	Исключение
		
		Результат = Неопределено;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Получает ссылку по уникальному идентификатору
//
// Параметры:
//  УникальныйИдентификатор  - УникальныйИдентификатор - Уникальный идентификатор
//  Тип  - Тип - Тип
//
// Возвращаемое значение:
//   Произвольный - Искомая ссылка
//
Функция СсылкаПоУникальномуИдентификатору(УникальныйИдентификатор, Тип) Экспорт
	
	УникальныйИдентификаторСтрока = Строка(УникальныйИдентификатор);
	Блок1 = Сред(УникальныйИдентификаторСтрока, 1, 8);
	Блок2 = Сред(УникальныйИдентификаторСтрока, 10, 4);
	Блок3 = Сред(УникальныйИдентификаторСтрока, 15, 4);
	Блок4 = Сред(УникальныйИдентификаторСтрока, 20, 4);
	Блок5 = Сред(УникальныйИдентификаторСтрока, 25, 12);
	
	ВнутреннийUID = Блок4 + Блок5 + Блок3 + Блок2 + Блок1;
	Возврат СсылкаПоВнутреннемуUID(ВнутреннийUID, Тип);
	
КонецФункции

Функция СсылкаПоПредставлениюБитойСсылки(Представление) Экспорт
	
	// Пример битой ссылки: <Объект не найден> (18:99496cf049ec417011eb07d748eb2481)
	
	НачалоБлока = СтрНайти(Представление, "(");
	Если НачалоБлока = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НачалоРазделителяБлока = СтрНайти(Представление, ":");
	Если НачалоРазделителяБлока = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	КонецБлока = СтрНайти(Представление, ")");
	Если КонецБлока = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИндексТипа = Сред(Представление, НачалоБлока + 1, НачалоРазделителяБлока - НачалоБлока - 1);
	ВнутреннийUID = Сред(Представление, НачалоРазделителяБлока + 1, КонецБлока - НачалоРазделителяБлока - 1);
	
	Тип = НайтиТипПоВнутреннемуИндексу(ИндексТипа);
	Если Тип = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат СсылкаПоВнутреннемуUID(ВнутреннийUID, Тип);
	
КонецФункции

// Вычисляет результат выполнения выражения
//
// Параметры:
//  Выражение  - Строка - Алгоритм на встроенном языке 1С:Предприятия.
//  БезопасныйРежим  - Булево - Признак включения безопасного режима
//
// Возвращаемое значение:
//   Произвольный, Структура - Результат вычисления выражения, в случае ошибки возвращается структура с текстом ошибки
//
Функция ВычислитьВыражение(Выражение, БезопасныйРежим = Истина) Экспорт
	
	Если БезопасныйРежим Тогда
		УстановитьБезопасныйРежим(Истина);
	КонецЕсли;
	
	Попытка
		
		// BSLLS:ExecuteExternalCodeInCommonModule-off
		Результат = Вычислить(Выражение);
		// BSLLS:ExecuteExternalCodeInCommonModule-on
		
	Исключение
		
		Результат = Новый Структура("Ошибка", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Преобразует (сериализует) любое значение в XML-строку.
// Преобразованы в могут быть только те объекты, для которых в синтакс-помощнике указано, что они сериализуются.
// См. также ЗначениеИзСтрокиXML.
//
// Параметры:
//  Значение - Произвольный - значение, которое необходимо сериализовать в XML-строку.
//
// Возвращаемое значение:
//  Строка - XML-строка.
//
Функция ЗначениеВСтрокуXML(Значение) Экспорт
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Значение, НазначениеТипаXML.Явное);
	
	Возврат ЗаписьXML.Закрыть();
	
КонецФункции

// Преобразует XML-строку в значение
// См. также ЗначениеВСтрокуXML.
//
// Параметры:
//  СтрокаXML - Строка - XML-строка, с сериализованным объектом..
//
// Возвращаемое значение:
//  Произвольный - значение, полученное из переданной XML-строки.
//
Функция ЗначениеИзСтрокиXML(СтрокаXML) Экспорт
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	Возврат СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
	
КонецФункции

Функция БитаяСсылка(Ссылка) Экспорт
	
	Если Ссылка.Пустая() Тогда
		
		Результат = Ложь;
		
	Иначе
		
		Результат = (ЗначениеРеквизитаОбъекта(Ссылка, "Ссылка") = Неопределено);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СсылкаПоНавигационнойСсылке(Строка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Строка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		
		МаркерСсылки = "?ref=";
	    НачалоСсылки = Найти(Строка, МаркерСсылки);
		Если НачалоСсылки = 0 Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Маркер = ИТКВ_Строки.МаркерНавигационнойСсылки();
		ДлинаМаркера = СтрДлина(Маркер);
	    НачалоМаркера = Найти(Строка, Маркер);
	    
	    ИмяТипа = Сред(Строка, НачалоМаркера + ДлинаМаркера, НачалоСсылки - НачалоМаркера - ДлинаМаркера);
		
		ПустоеЗначениеВнутр = ЗначениеВСтрокуВнутр(ПредопределенноеЗначение(ИмяТипа + ".ПустаяСсылка"));
	    ЗначениеВнутр = СтрЗаменить(ПустоеЗначениеВнутр, ИТКВ_Строки.ПустойUID(), Сред(Строка, НачалоСсылки + СтрДлина(МаркерСсылки)));
		
		Результат = ЗначениеИзСтрокиВнутр(ЗначениеВнутр);
	
	Исключение
	
		Результат = Неопределено;
	
	КонецПопытки;
	
	Возврат Результат;
    
КонецФункции

Функция СоздатьВременныйКаталог() Экспорт
	
	Результат = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(Результат);
	
	Возврат Результат;
	
КонецФункции

Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита) Экспорт
	
	Результат = ЗначенияРеквизитовОбъекта(Ссылка, ИмяРеквизита);
	Возврат Результат[ИмяРеквизита];
	
КонецФункции

Функция ЗначенияРеквизитовОбъекта(Ссылка, Знач Реквизиты) Экспорт
	
	ПолноеИмяОбъектаМетаданных = Ссылка.Метаданные().ПолноеИмя();
	
	ШаблонТекстаЗапроса = "ВЫБРАТЬ %1 ИЗ %2 КАК Таблица ГДЕ Таблица.Ссылка = &Ссылка";
	ТекстЗапроса = СтрШаблон(ШаблонТекстаЗапроса, Реквизиты, ПолноеИмяОбъектаМетаданных);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Новый Структура(Реквизиты);
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИнформацияДляТехническойПоддержки() Экспорт
	
	Результат = Новый Массив;
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	// ИНФОРМАЦИЯ О СЕРВЕРЕ
	// Версия платформы 1С
	Шаблон = НСтр("ru = 'Платформа: %1 (%2)'; en = 'Platform: %1 (%2)'");
	Текст = СтрШаблон(Шаблон, СистемнаяИнформация.ВерсияПриложения, СистемнаяИнформация.ТипПлатформы);
	Результат.Добавить(Текст);
	
	// Режим работы базы данных
	Если ИТКВ_ОбщийКлиентСерверПовтИсп.ИнформационнаяБазаФайловая() Тогда
		Режим = НСтр("ru = 'файловый'; en = 'file'");
	Иначе
		Режим = НСтр("ru = 'клиент-серверный'; en = 'client-server'");
	КонецЕсли;
	Шаблон = НСтр("ru = 'Режим БД: %1'; en = 'Mode IB: %1'");
	Текст = СтрШаблон(Шаблон, Режим);
	Результат.Добавить(Текст);
	
	Результат.Добавить("");
	
	// ИНФОРМАЦИЯ О КОНФИГУРАЦИИ
	Результат.Добавить(НСтр("ru = 'Конфигурация:'; en = 'Configuration:'"));
	
	// Наименование и версия конфигурации
	Шаблон = "%1 (%2)";
	Текст = СтрШаблон(Шаблон, Метаданные.Представление(), Метаданные.Версия);
	Результат.Добавить(Текст);
	
	// Основной режим запуска
	Шаблон = НСтр("ru = 'Основной режим запуска: %1'; en = 'Basic launch mode: %1'");
	Текст = СтрШаблон(Шаблон, Метаданные.ОсновнойРежимЗапуска);
	Результат.Добавить(Текст);
	
	// Режим совместимости
	Шаблон = НСтр("ru = 'Режим совместимости: %1'; en = 'Compatibility mode: %1'");
	Текст = СтрШаблон(Шаблон, Метаданные.РежимСовместимости);
	Результат.Добавить(Текст);
	
	// Версия БСП
	Шаблон = НСтр("ru = 'Версия БСП: %1'; en = 'SSL version: %1'");
	ВерсияБСП = ИТКВ_БСПКлиентСерверПовтИсп.Версия();
	Если ВерсияБСП = Неопределено Тогда
		ВерсияБСП = НСтр("ru = 'БСП не установлена'; en = 'SSL not installed'");
	КонецЕсли;
	Текст = СтрШаблон(Шаблон, ВерсияБСП);
	Результат.Добавить(Текст);

	Возврат СтрСоединить(Результат, Символы.ПС);
	
КонецФункции

Функция КэшВыделенияОсобыхЗначений(ТипыЗначений) Экспорт
	
	Результат = Новый Соответствие;
	Результат.Вставить(0, "<0>");
	Результат.Вставить(Null, "<NULL>");
	Результат.Вставить("", НСтр("ru = '<Пустая строка>'; en = '<Empty string>'"));
	Результат.Вставить(ИТКВ_ОбщийКлиентСервер.ПустаяДата(), НСтр("ru = '<Пустая дата>'; en = '<Empty date>'"));
	
	ПустойУникальныйИдентификатор = Новый УникальныйИдентификатор(ИТКВ_Строки.ПустойУникальныйИдентификатор());
	Результат.Вставить(ПустойУникальныйИдентификатор, НСтр("ru = '<Пустой уникальный идентификатор>'; en = '<Unique identifier empty>'"));
	
	// Имеет смысл с платформы старше 8.3.21 влияет режим совместимости
	// https://dl03.1c.ru/content/Platform/8_3_21_1140/1cv8upd_8_3_21_1140.htm#96802afd-0028-11ec-8371-0050569f678a
	Результат.Вставить(Неопределено, НСтр("ru = '<Неопределено>'; en = '<Undefined>'"));
	
	Для Каждого ТипЗначения Из ТипыЗначений Цикл
		
		Для Каждого Тип Из ТипЗначения.Типы() Цикл
			
			Если НЕ ИТКВ_ТипыКлиентСервер.ЭтоСсылочный(Тип) Тогда
				Продолжить;
			КонецЕсли;
				
			ПустаяСсылка = Новый (Тип);
			Если Результат.Получить(ПустаяСсылка) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
			ШаблонПредставления = НСтр("ru = '<Пустая ссылка: %1>'; en = '<Empty link: %1>'");
			Представление = СтрШаблон(ШаблонПредставления, ИТКВ_Метаданные.ПолноеИмя(ОбъектМетаданных));
			
			Результат.Вставить(ПустаяСсылка, Представление);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ВариантВстроенногоЯзыкаРусский() Экспорт
	
	Возврат (Метаданные.ВариантВстроенногоЯзыка = Метаданные.СвойстваОбъектов.ВариантВстроенногоЯзыка.Русский);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НайтиТипПоВнутреннемуИндексу(Индекс)
	
	СтруктураХраненияБазыДанных = ИТКВ_ОбщийПовтИсп.СтруктураХраненияБазыДанных();
	
	Строка = СтруктураХраненияБазыДанных.Найти(Индекс, "Индекс");
	Если Строка = Неопределено Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(Строка.Метаданные);
	ИмяОбъектаКоллекции = ИТКВ_Метаданные.ИмяОбъектаКоллекции(ОбъектМетаданных);
	
	ТипСсылка = ИТКВ_МетаданныеКлиентСервер.ТипСсылка(ИмяОбъектаКоллекции, ОбъектМетаданных.Имя);
	
	Возврат Тип(ТипСсылка);
	
КонецФункции

#КонецОбласти
