﻿#Область ПрограммныйИнтерфейс

// Получает структуру данных по Текущим данным
//
// Параметры:
//  ТипСтроки - Перечисление.ИТКВ_ЭлементыДанных - Тип строки
//  Сохранение - Булево - Для сохранения
//
// Возвращаемое значение:
//   Структура - Данные строки
//
Функция НовыйЭлемент(ТипСтроки, Сохранение = Ложь) Экспорт
	
	Результат = Новый Структура;

	Если Сохранение Тогда
		
		Результат.Вставить("Имя", Неопределено);
		Результат.Вставить("Выделение", Ложь);
		Результат.Вставить("Тип", ТипСтроки);
		Если ЭтоТипСтрокиСодержащийСохраняемыеСтроки(ТипСтроки) Тогда
			Результат.Вставить("Развернуто", Истина);
		КонецЕсли;
		
	Иначе
		
		Результат.Вставить("Страница", "");
		
	КонецЕсли;
	
	Если ТипСтроки = ИТКВ_Перечисления.ЭлементДанныхЗапрос() Тогда
		
		Результат.Вставить("МаксимумСтрок", Неопределено); // Важно. Строка должна быть перед строкой Текст (т.к. при записи XML ошибка неверный порядок)
		Результат.Вставить("Текст", "");
		Результат.Вставить("ЗначенияПараметров", Новый Соответствие);
		Результат.Вставить("НастройкиВыводаТаблиц", Новый Соответствие);
		Результат.Вставить("АлгоритмыОбработки", Новый СписокЗначений);
		
		Если Не Сохранение Тогда
			
			Результат.Вставить("Параметры", Новый Соответствие);
			Результат.Вставить("ВременныеТаблицы", Новый Соответствие);
			Результат.Вставить("ТребуетсяПроверка", Ложь);
			Результат.Вставить("ВремяВыполнения", Неопределено);
			Результат.Вставить("Ошибка", ИТКВ_ЗапросКлиентСервер.ИнформацияООшибке(ИТКВ_ЗапросКлиентСервер.ТекстОшибкиПустойЗапрос()));
			Результат.Вставить("ОшибкаПриВыполнении", Неопределено);
			Результат.Вставить("Страница", "ТекстЗапроса");
			
		КонецЕсли;
		
	ИначеЕсли ТипСтроки = ИТКВ_Перечисления.ЭлементДанныхСхемаКомпоновкиДанных() Тогда
		
		Результат.Вставить("Текст", "");
		Результат.Вставить("ИспользованиеВнешнихФункций", Истина);
		
		Если Не Сохранение Тогда
			
			Результат.Вставить("ТребуетсяПроверка", Ложь);
			Результат.Вставить("ВремяВыполнения", Неопределено);
			Результат.Вставить("Ошибка", ИТКВ_СКДКлиентСервер.ИнформацияООшибке(ИТКВ_СКДКлиентСервер.ТекстОшибкиПустаяСхема()));
			Результат.Вставить("ОшибкаПриВыполнении", Неопределено);
			
		КонецЕсли;
		
	ИначеЕсли ТипСтроки = ИТКВ_Перечисления.ЭлементДанныхВариантОтчетаСКД() Тогда
		
		Результат.Вставить("Текст", "");
		
		Если Не Сохранение Тогда
			
			Результат.Вставить("ВремяВыполнения", Неопределено);
			Результат.Вставить("Ошибка", Неопределено);
			Результат.Вставить("ОшибкаПриВыполнении", Неопределено);
			
		КонецЕсли;
		
	ИначеЕсли ТипСтроки = ИТКВ_Перечисления.ЭлементДанныхПользовательскаяНастройкаСКД() Тогда
		
		Результат.Вставить("Текст", "");
		
		Если Не Сохранение Тогда
			
			Результат.Вставить("ВремяВыполнения", Неопределено);
			Результат.Вставить("Ошибка", Неопределено);
			Результат.Вставить("ОшибкаПриВыполнении", Неопределено);
			
		КонецЕсли;
		
	ИначеЕсли ТипСтроки = ИТКВ_Перечисления.ЭлементДанныхКод() Тогда
		
		Результат.Вставить("Текст", "");
		
		Если Не Сохранение Тогда
			
			Результат.Вставить("ВремяВыполнения", Неопределено);
			Результат.Вставить("ОшибкаПриВыполнении", Неопределено);
			Результат.Вставить("Страница", "Код");
			
		КонецЕсли;
		
	ИначеЕсли ТипСтроки = ИТКВ_Перечисления.ЭлементДанныхПодзапрос() Тогда // Подзапрос не сохраняется
		
		Результат.Вставить("ТекстИнициализации", "");
		Результат.Вставить("Текст", "");
		Результат.Вставить("Параметры", Новый Массив);
		Результат.Вставить("ВремяВыполнения", Неопределено);
		Результат.Вставить("Ошибка", Неопределено);
		Результат.Вставить("ОшибкаПриВыполнении", Неопределено);
		
	КонецЕсли;
	
	Если ЭтоТипСтрокиСИспользованиемТекста(ТипСтроки) Тогда
		
		Если Не Сохранение Тогда
			
			Результат.Вставить("Закладки", Новый Массив);
			Результат.Вставить("СостояниеРедактора", Неопределено);
			
			ГраницыВыделения = ИТКВ_РедакторКодаКлиентСервер.ПустойГраницыВыделения();
			Результат.Вставить("ГраницыВыделенияТекста", ГраницыВыделения);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоТипСтрокиСИспользованиемВнешнихИсточников(ТипСтроки) Тогда
		
		Результат.Вставить("ВнешниеИсточники", Новый Соответствие);
		
		Если Не Сохранение Тогда
			Результат.Вставить("ОписаниеВнешнихИсточников", Новый Соответствие);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоТипСтрокиСИспользованиемОригинальногоТекста(ТипСтроки) Тогда
		
		Если НЕ Сохранение Тогда
			Результат.Вставить("ОригинальныйТекст", "");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет это один из типов строки СКД
//
// Параметры:
//   Тип - Перечисление.ИТКВ_ЭлементыДанных - Тип
//
// Возвращаемое значение:
//   Булево - Истина, если это один из типов СКД
//
Функция ЭтоОдинИзТиповСтрокиСКД(Тип) Экспорт
	
	Типы = ТипыСтрокСКД();
	Возврат	(Типы.Найти(Тип) <> Неопределено);
				
КонецФункции

Функция ТипыСтрокСКД() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(ИТКВ_Перечисления.ЭлементДанныхСхемаКомпоновкиДанных());
	Результат.Добавить(ИТКВ_Перечисления.ЭлементДанныхВариантОтчетаСКД());
	Результат.Добавить(ИТКВ_Перечисления.ЭлементДанныхПользовательскаяНастройкаСКД());
	
	Возврат Результат;
	
КонецФункции

// Проверяет это один из типов строки запрос, вложенный запрос
//
// Параметры:
//   Тип - Перечисление.ИТКВ_ЭлементыДанных - Тип
//
// Возвращаемое значение:
//   Булево - Истина, если это один из типов запрос
//
Функция ЭтоОдинИзТиповСтрокиЗапрос(Тип) Экспорт

	Типы = ТипыСтрокЗапросПодзапрос();
	Возврат	(Типы.Найти(Тип) <> Неопределено);
				
КонецФункции
			
Функция ТипыСтрокЗапросПодзапрос() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(ИТКВ_Перечисления.ЭлементДанныхЗапрос());
	Результат.Добавить(ИТКВ_Перечисления.ЭлементДанныхПодзапрос());
	
	Возврат Результат;
	
КонецФункции

// Проверяет это один из типов который может содержать сохраняемые подчиненные строки
//
// Параметры:
//   Тип - Перечисление.ИТКВ_ЭлементыДанных - Тип
//
// Возвращаемое значение:
//   Булево - Истина, если это один из типов
//
Функция ЭтоОдинИзТиповСтрокиСодержащийСохраняемыеСтроки(Тип) Экспорт
	
	Возврат	Тип = ИТКВ_Перечисления.ЭлементДанныхГруппа()
				ИЛИ Тип = ИТКВ_Перечисления.ЭлементДанныхСхемаКомпоновкиДанных()
				ИЛИ Тип = ИТКВ_Перечисления.ЭлементДанныхВариантОтчетаСКД();
				
КонецФункции
		
Функция ПереносСтрокиВнутрь(Приемник, Источник) Экспорт
	
	// 1. В группу переносится любой элемент
	// 2. В СКД переносится ВариантОтчетаСКД или ПользовательскаяНастройкаСКД
	// 3. В ВариантОтчетаСКД переносится ПользовательскаяНастройкаСКД
	
	Возврат Приемник = ИТКВ_Перечисления.ЭлементДанныхГруппа() // 1
				ИЛИ (Приемник = ИТКВ_Перечисления.ЭлементДанныхСхемаКомпоновкиДанных() // 2
						И (Источник = ИТКВ_Перечисления.ЭлементДанныхВариантОтчетаСКД()
								ИЛИ Источник = ИТКВ_Перечисления.ЭлементДанныхПользовательскаяНастройкаСКД()))
				ИЛИ (Приемник = ИТКВ_Перечисления.ЭлементДанныхВариантОтчетаСКД() // 3 
						И Источник = ИТКВ_Перечисления.ЭлементДанныхПользовательскаяНастройкаСКД());
	
КонецФункции

// Проверяет это один из типов который может содержать сохраняемые подчиненные строки
//
// Параметры:
//   Тип - Перечисление.ИТКВ_ЭлементыДанных - Тип
//
// Возвращаемое значение:
//   Булево - Истина, если это один из типов
//
Функция ЭтоТипСтрокиСодержащийСохраняемыеСтроки(Тип) Экспорт
	
	Возврат	Тип = ИТКВ_Перечисления.ЭлементДанныхГруппа()
				ИЛИ Тип = ИТКВ_Перечисления.ЭлементДанныхСхемаКомпоновкиДанных()
				ИЛИ Тип = ИТКВ_Перечисления.ЭлементДанныхВариантОтчетаСКД();
				
КонецФункции

// Проверяет это один из типов в котором используются внешние источники
//
// Параметры:
//   Тип - Перечисление.ИТКВ_ЭлементыДанных - Тип
//
// Возвращаемое значение:
//   Булево - Истина, если это один из типов
//
Функция ЭтоТипСтрокиСИспользованиемВнешнихИсточников(Тип) Экспорт
	
	Возврат	Тип = ИТКВ_Перечисления.ЭлементДанныхЗапрос()
				ИЛИ Тип = ИТКВ_Перечисления.ЭлементДанныхСхемаКомпоновкиДанных();
				
КонецФункции

Функция ЭтоТипСтрокиСИспользованиемТекста(Тип) Экспорт
	
	Возврат	Тип = ИТКВ_Перечисления.ЭлементДанныхЗапрос()
				ИЛИ Тип = ИТКВ_Перечисления.ЭлементДанныхПодзапрос()
				ИЛИ Тип = ИТКВ_Перечисления.ЭлементДанныхСхемаКомпоновкиДанных()
				ИЛИ Тип = ИТКВ_Перечисления.ЭлементДанныхКод();
				
КонецФункции

Функция ЭтоТипСтрокиСИспользованиемОригинальногоТекста(Тип) Экспорт
	
	Возврат	Тип = ИТКВ_Перечисления.ЭлементДанныхЗапрос()
				ИЛИ Тип = ИТКВ_Перечисления.ЭлементДанныхСхемаКомпоновкиДанных()
				ИЛИ Тип = ИТКВ_Перечисления.ЭлементДанныхКод();
				
КонецФункции

Функция ДоступноРедактированиеТекстаДляСтроки(Тип) Экспорт
	
	Возврат	Тип = ИТКВ_Перечисления.ЭлементДанныхЗапрос()
				ИЛИ Тип = ИТКВ_Перечисления.ЭлементДанныхСхемаКомпоновкиДанных()
				ИЛИ Тип = ИТКВ_Перечисления.ЭлементДанныхКод();
				
КонецФункции

Функция КорректнаяОперацияВыполнения(Тип, Режим) Экспорт
	
	Результат = Истина;
	Если ТипЗнч(Режим) = Тип("Строка") Тогда
		
		Если ЭтоОдинИзТиповСтрокиЗапрос(Тип) Тогда
			
			Если Режим = "Выполнение" Тогда
				Режим = ИТКВ_Перечисления.РежимВыполненияЗапросаВыполнение();
			ИначеЕсли Режим = "Замер" Тогда
				Режим = ИТКВ_Перечисления.РежимВыполненияЗапросаЗамер();
			КонецЕсли;
			
		ИначеЕсли ЭтоОдинИзТиповСтрокиСКД(Тип) Тогда
			
			Если Режим = "Выполнение" Тогда
				Режим = ИТКВ_Перечисления.РежимВыполненияСКДВыполнение();
			ИначеЕсли Режим = "Замер" Тогда
				Режим = ИТКВ_Перечисления.РежимВыполненияСКДЗамер();
			КонецЕсли;
			
		ИначеЕсли Тип = ИТКВ_Перечисления.ЭлементДанныхКод() Тогда
			
			Если Режим = "Выполнение" Тогда
				Режим = ИТКВ_Перечисления.РежимВыполненияКодаВыполнение();
			ИначеЕсли Режим = "Замер" Тогда
				Режим = ИТКВ_Перечисления.РежимВыполненияКодаЗамер();
			КонецЕсли;
			
		Иначе
			
			Результат = Ложь;
			
		КонецЕсли;
		
	Иначе
		
		РежимВыполненияЗапроса = (Режим = ИТКВ_Перечисления.РежимВыполненияЗапросаВыполнение())
									ИЛИ (Режим = ИТКВ_Перечисления.РежимВыполненияЗапросаЗамер())
									ИЛИ (Режим = ИТКВ_Перечисления.РежимВыполненияЗапросаСРезультатамиВременныхТаблиц());
		РежимВыполненияКода = (Режим = ИТКВ_Перечисления.РежимВыполненияКодаВыполнение())
									ИЛИ (Режим = ИТКВ_Перечисления.РежимВыполненияКодаЗамер())
									ИЛИ (Режим = ИТКВ_Перечисления.РежимВыполненияКодаНаКлиенте());
		РежимВыполненияСКД = (Режим = ИТКВ_Перечисления.РежимВыполненияСКДВыполнение())
									ИЛИ (Режим = ИТКВ_Перечисления.РежимВыполненияСКДЗамер())
									ИЛИ (Режим = ИТКВ_Перечисления.РежимВыполненияСКДПолучениеИсполняемыхЗапросов());
		Если РежимВыполненияЗапроса И Не ЭтоОдинИзТиповСтрокиЗапрос(Тип)
				ИЛИ РежимВыполненияСКД И Не ЭтоОдинИзТиповСтрокиСКД(Тип)
				ИЛИ РежимВыполненияКода И НЕ Тип = ИТКВ_Перечисления.ЭлементДанныхКод() Тогда
				
			Результат = Ложь
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает описание нового внешнего источника
//
// Параметры:
//   Имя - Строка - Имя
//   Тип - Перечисление.ИТКВ_ТипыЗначенийВнешнегоИсточника - Тип значения внешнего источника
//   Значение - Строка - Значение
//
// Возвращаемое значение:
//   Структура	- Описание нового внешнего источника
//
Функция НовыйВнешнийИсточник(Имя = Неопределено, Тип = Неопределено, Значение = Неопределено) Экспорт
	
	Возврат Новый Структура("Имя, Тип, Значение", Имя, Тип, Значение);
	
КонецФункции

// Возвращает описание вывода временной таблицы
//
// Параметры:
//   Вывод - Перечисление.ИТКВ_ВыводВременнойТаблицы - Вывод временной таблицы
//
// Возвращаемое значение:
//   Структура	- Описание вывода временной таблицы
//
Функция ОписаниеНастройкиВыводаТаблицы(Вывод = Неопределено) Экспорт
	
	Если Вывод = Неопределено Тогда
		Вывод = ИТКВ_Перечисления.ВидВыводаТаблицыВыводить();
	КонецЕсли;
	
	Возврат Новый Структура("Вывод", Вывод);
	
КонецФункции

// Получает описание настроек вывода временной таблицы
//
// Параметры:
//   Данные - Данные - Данные
//   Имя - Строка - Имя временной таблицы
//
// Возвращаемое значение:
//   Структура	- Описание настроек вывода временной таблицы
//
Функция ПолучитьОписаниеНастройкиВыводаТаблицы(Данные, Имя) Экспорт
	
	Результат = Данные.НастройкиВыводаТаблиц.Получить(Имя);
	Если Результат = Неопределено Тогда
		Результат = ОписаниеНастройкиВыводаТаблицы();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получает структуру данных по Текущим данным
//
// Параметры:
//  Строка - ДанныеФормыЭлементДерева - Данные строки по которым получается структура
//
// Возвращаемое значение:
//   Структура - Данные строки
//
Функция Получить(Строка) Экспорт
	
	Если Строка = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Строка.Данные;
	
КонецФункции

Процедура ДанныеМодифицированы(Форма, АвтоСохранение = Истина) Экспорт
	
	Форма.Модифицированность = Истина;
	
	Если АвтоСохранение Тогда
		Форма.МодифицированностьАвтоСохранение = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура СброситьМодифицированность(Форма, АвтоСохранение = Истина) Экспорт
	
	Форма.Модифицированность = Ложь;
	
	Если АвтоСохранение Тогда
		Форма.МодифицированностьАвтоСохранение = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура СброситьОригинальныйТекст(Данные) Экспорт
	
	Данные["ОригинальныйТекст"] = Данные["Текст"];
	
КонецПроцедуры

Функция ТипПараметраТаблицаЗначений(ОписаниеТипов) Экспорт
	
	Возврат (ТипЗнч(ОписаниеТипов) = Тип("Структура")
				ИЛИ ОписаниеТипов = ИТКВ_Перечисления.СложныйПараметрЗапросаТаблицаЗначений());
	
КонецФункции

// Возвращает внешние источники
//
// Параметры:
//  Данные - Данные - Данные
//
// Возвращаемое значение:
//   Соответствие - Данные внешних источников
//
Функция ВнешниеИсточники(Данные) Экспорт
	
	Если Данные = Неопределено Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Возврат Данные.ВнешниеИсточники;
	
КонецФункции

#КонецОбласти

