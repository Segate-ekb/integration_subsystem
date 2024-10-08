﻿#Область ПрограммныйИнтерфейс

// Выполняет обработку строк
//
// Параметры:
//  ОбрабатываемыеДанные  - ТаблицаЗначений - Обрабатываемые данные
//  ОписаниеАлгоритма  - Структура - Описание алгоритма
//  ЗначенияПараметров  - Соответствие - Значения параметров
//  ОбрабатываемыеСтроки  - Массив - Обрабатываемые строки
//	АдресРезультатаВыполнения - Строка - Адрес временного хранилища результата выполнения
//
// Возвращаемое значение:
//   СписокЗначений - Данные по обработке
//
Процедура Обработать(Параметры, АдресРезультата = Неопределено) Экспорт
	
	ВыполнениеЧерезДлительныеОперации = (АдресРезультата <> Неопределено);
	
	ОписаниеАлгоритма = Параметры.ОписаниеАлгоритма;
	ЗначенияПараметров = Параметры.ЗначенияПараметров;
	ОбрабатываемыеДанные = Параметры.ОбрабатываемыеДанные;
	ОбрабатываемыеСтроки = Параметры.ОбрабатываемыеСтроки;
	ДополнительныеСвойства = Параметры.ДополнительныеСвойства;
	
	НачалоВыполнения = ТекущаяДатаСеанса();
	КоличествоСтрок = КоличествоСтрок(ОбрабатываемыеДанные, ОбрабатываемыеСтроки);
	
	// Инициализация транзакции
	ОбработкаВТранзакции = (ОписаниеАлгоритма.Транзакция = ИТКВ_Перечисления.ТипТранзакцииОбработкиРезультатаНаВсе());
	ЗафиксироватьТранзакцию = Истина;
	Если ОбработкаВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	
	// Выполнение кода перед (Инициализация)
	Если ВыполнениеЧерезДлительныеОперации Тогда
		
		Если ЗначениеЗаполнено(ОписаниеАлгоритма.КодПеред) Тогда
			
			ИТКВ_ДлительныеОперацииКлиентСервер.СообщениеНачалоОбработкиОбъекта(ИТКВ_ОбработкаРезультатаКлиентСервер.НомерСтрокиКодПеред());
			Ошибка = ВыполнитьКодОбработки(ОписаниеАлгоритма.КодПеред, ЗначенияПараметров, ДополнительныеСвойства, ОбрабатываемыеДанные);
			ИТКВ_ДлительныеОперацииКлиентСервер.СообщениеКонецОбработкиОбъекта(Ошибка);
			
			Если ЗначениеЗаполнено(Ошибка) Тогда
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Подготовка алгоритма и контекста
	ИдентификаторСтрокиRU = ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторСтроки("ru");
	ИдентификаторСтрокиEN = ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторСтроки("en");
	Контекст = Новый Структура;
	Контекст.Вставить(ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторПараметры("ru"), ЗначенияПараметров);
	Контекст.Вставить(ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторПараметры("en"), ЗначенияПараметров);
	Контекст.Вставить(ИдентификаторСтрокиRU);
	Контекст.Вставить(ИдентификаторСтрокиEN);
	Контекст.Вставить(ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторДополнительныеСвойства("ru"), ДополнительныеСвойства);
	Контекст.Вставить(ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторДополнительныеСвойства("en"), ДополнительныеСвойства);
	АлгоритмРаботыСКонтекстом = АлгоритмРаботыВКонтексте(Контекст);
	
	ПоследняяДата = ТекущаяДатаСеанса();
	Для ИндексСтроки = 0 По КоличествоСтрок - 1 Цикл
		
		ИндексОбрабатываемойСтроки = ИндексОбрабатываемойСтроки(ОбрабатываемыеСтроки, ИндексСтроки);
		
		ОбрабатываемаяСтрока = ОбрабатываемыеДанные[ИндексОбрабатываемойСтроки];
		Контекст[ИдентификаторСтрокиRU] = ОбрабатываемаяСтрока;
		Контекст[ИдентификаторСтрокиEN] = ОбрабатываемаяСтрока;
		
		ИТКВ_ДлительныеОперацииКлиентСервер.СообщениеНачалоОбработкиОбъекта(ИндексОбрабатываемойСтроки);
		Ошибка = ОбработатьСтроку(ОбрабатываемаяСтрока, АлгоритмРаботыСКонтекстом, ОписаниеАлгоритма, Контекст);
		ИТКВ_ДлительныеОперацииКлиентСервер.СообщениеКонецОбработкиОбъекта(Ошибка);
		
		Если ЗначениеЗаполнено(Ошибка) Тогда
			
			ЗафиксироватьТранзакцию = Ложь;
			Если ОписаниеАлгоритма.ПрерыватьПриОшибке Тогда
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Выполнение кода после (Завершение)
	Если ВыполнениеЧерезДлительныеОперации Тогда
		
		Если ЗначениеЗаполнено(ОписаниеАлгоритма.КодПосле) Тогда
			
			ИТКВ_ДлительныеОперацииКлиентСервер.СообщениеНачалоОбработкиОбъекта(ИТКВ_ОбработкаРезультатаКлиентСервер.НомерСтрокиКодПосле());
			Ошибка = ВыполнитьКодОбработки(ОписаниеАлгоритма.КодПосле, ЗначенияПараметров, ДополнительныеСвойства);
			ИТКВ_ДлительныеОперацииКлиентСервер.СообщениеКонецОбработкиОбъекта(Ошибка)
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Фиксация/отмена транзакция
	Если ОбработкаВТранзакции Тогда
		
		Если ЗафиксироватьТранзакцию Тогда
			ЗафиксироватьТранзакцию();
		Иначе
			ОтменитьТранзакцию();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Получает представление объекта журнала
//
// Параметры:
//  ОбрабатываемыеДанные  - ТаблицаЗначений - Обрабатываемые данные
//  Индекс  - Число - Индекс объекта
//
// Возвращаемое значение:
//   Строка - Представление объекта журнала
//
Функция ПредставлениеОбъектаЖурнала(ОбрабатываемыеДанные, Индекс) Экспорт
	
	Результат = ИТКВ_ОбработкаРезультатаКлиентСервер.ПредставлениеИндексаОбъекта(Индекс);
	Если Не ИТКВ_ОбработкаРезультатаКлиентСервер.ЭтоИндексОбъекта(Индекс) Тогда
		
		Возврат Результат;
		
	КонецЕсли;
	
	Если ТипЗнч(ОбрабатываемыеДанные) = Тип("Массив") Тогда
		
		Объект = ОбрабатываемыеДанные[Индекс];
		
		Если ИТКВ_МетаданныеКлиентСервер.ЭтоТипКлючЗаписиРегистраСведений(ТипЗнч(Объект)) Тогда
			
			Результат = ИТКВ_Метаданные.ПредставлениеКлючаЗаписейРегистраСведений(Объект);
			
		Иначе
			
			Результат = ОбрабатываемыеДанные[Индекс];
			
		КонецЕсли;
		
	Иначе
		
		ЗначенияКолонок = Новый Массив;
		
		ВерхняяГраницаИндекса = Мин(ОбрабатываемыеДанные.Колонки.Количество() - 1, 2); // не более 3 колонок
		Для ИндексКолонки = 0 По ВерхняяГраницаИндекса Цикл
			
			ЗначенияКолонок.Добавить(Строка(ОбрабатываемыеДанные[Индекс][ОбрабатываемыеДанные.Колонки[ИндексКолонки].Имя]));
			
		КонецЦикла;
		
		Значение = СтрСоединить(ЗначенияКолонок, ", ");
		Представление = ИТКВ_Строки.Сократить(Значение, 100);
		Результат = СтрШаблон("%1 (%2)", Результат, Представление);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ВыполнитьКодОбработки(Код, ЗначенияПараметров, ДополнительныеСвойства, ОбрабатываемыеДанные = Неопределено) Экспорт
	
	Результат = "";
		
	Контекст = Новый Структура;
	Контекст.Вставить(ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторПараметры(), ЗначенияПараметров);
	Контекст.Вставить(ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторПараметры("en"), ЗначенияПараметров);
	Контекст.Вставить(ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторДополнительныеСвойства(), ДополнительныеСвойства);
	Контекст.Вставить(ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторДополнительныеСвойства("en"), ДополнительныеСвойства);
	
	Если ОбрабатываемыеДанные <> Неопределено Тогда
		Контекст.Вставить(ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторОбрабатываемыхДанных(), ОбрабатываемыеДанные);
		Контекст.Вставить(ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторОбрабатываемыхДанных("en"), ОбрабатываемыеДанные);
	КонецЕсли;
	
	АлгоритмРаботыСКонтекстом = АлгоритмРаботыВКонтексте(Контекст);
		
	Результат = ИТКВ_Общий.ВыполнитьСКонтекстом(АлгоритмРаботыСКонтекстом, Код, Контекст);

	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет произвольный алгоритм на встроенном языке 1С:Предприятия, 
// обрабатывая строку результата - таблицы значений
//
// Параметры:
//  ОбрабатываемаяСтрока  - СтрокаТаблицыЗначений - Обрабатываемая строка таблицы значений
//  ОписаниеАлгоритма  - Структура - Описание алгоритма
//  Параметры  - Структура - Значения параметров алгоритма
//
// Возвращаемое значение:
//  Ошибка - Строка - Текст ошибки
//
Функция ОбработатьСтроку(ОбрабатываемаяСтрока, АлгоритмРаботыСКонтекстом, ОписаниеАлгоритма, Контекст)
	
	ОбработкаВТранзакции = (ОписаниеАлгоритма.Транзакция = ИТКВ_Перечисления.ТипТранзакцииОбработкиРезультатаПоСтроке());
	
	Если ОбработкаВТранзакции Тогда
		
		НачатьТранзакцию();
		Результат = ИТКВ_Общий.ВыполнитьСКонтекстом(АлгоритмРаботыСКонтекстом, ОписаниеАлгоритма.Код, Контекст);
		
		Если ЗначениеЗаполнено(Результат) Тогда
			
			ОтменитьТранзакцию();
			
		Иначе
			
			ЗафиксироватьТранзакцию();
			
		КонецЕсли;
		
	Иначе
		
		Результат = ИТКВ_Общий.ВыполнитьСКонтекстом(АлгоритмРаботыСКонтекстом, ОписаниеАлгоритма.Код, Контекст);
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция АлгоритмРаботыВКонтексте(Контекст, БезопасныйРежим = Ложь)
	
	СтрокиКода = Новый Массив;
	Для Каждого ЭлементКонтекста Из Контекст Цикл
		СтрокиКода.Добавить(СтрШаблон("%1 = Контекст.%1;", ЭлементКонтекста.Ключ));
	КонецЦикла;
	
	СтрокиКода.Добавить("");
	
	Если БезопасныйРежим Тогда
		УстановитьБезопасныйРежим(Истина);
		СтрокиКода.Добавить("УстановитьБезопасныйРежим(Истина);");
	КонецЕсли;
	
	СтрокиКода.Добавить("Попытка
	|	Выполнить Алгоритм;
	|Исключение
	|	ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	|КонецПопытки;");
	
	Возврат СтрСоединить(СтрокиКода, Символы.ПС);
	
КонецФункции

// Получает количество строк в обрабатываемом пакете
//
// Параметры:
//  ОбрабатываемыеДанные  - ТаблицаЗначений - Обрабатываемые данные
//  ОбрабатываемыеСтроки  - Соответствие - Набор номеров обрабатываемых строк
//
// Возвращаемое значение:
//   Число - Количество строк в обрабатываемом пакете
//
Функция КоличествоСтрок(ОбрабатываемыеДанные, ОбрабатываемыеСтроки)
	
	Если ОбрабатываемыеСтроки = Неопределено Тогда
		Результат = ОбрабатываемыеДанные.Количество();
	Иначе
		Результат = ОбрабатываемыеСтроки.Количество();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получает индекс обрабатываемой строки пакета
//
// Параметры:
//  ОбрабатываемыеСтроки  - Неопределено, Массив - Обрабатываемые строки
//  ИндексСтроки  - Число - Индекс строки
//
// Возвращаемое значение:
//   Число - индекс обрабатываемой строки пакета
//
Функция ИндексОбрабатываемойСтроки(ОбрабатываемыеСтроки, ИндексСтроки)
	
	Если ОбрабатываемыеСтроки = Неопределено Тогда
		Результат = ИндексСтроки;
	Иначе
		Результат = ОбрабатываемыеСтроки[ИндексСтроки];
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
