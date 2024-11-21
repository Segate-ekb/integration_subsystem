﻿// BSLLS:NestedFunctionInParameters-off

#Область ПрограммныйИнтерфейс

// Возвращает список ошибок модели данных.
//
// Параметры:
//  МодельДанных - Структура - Проверяемый объект.
//               - Массив   - Проверяемый объект.
//  ИмяСхемы     - Строка - Имя схемы данных из спецификации.
//  Спецификация - Строка, СправочникСсылка.инт_Схемы - Спецификация OpenAPI 3.0 в формате JSON или ссылка на справочник ее содержащий.
// 
// Возвращаемое значение:
//  Массив - Список ошибок.
//
Функция Валидировать(Знач МодельДанных, Знач ИмяСхемы = Неопределено, Знач Спецификация = Неопределено) Экспорт
	
	ОшибкиПроверкиМоделиДанныхПоСпецификации = Новый Массив;
	СхемыДанныхСпецификации = инт_ВалидаторПакетовПовтИсп.СхемыДанныхСпецификации(Спецификация);
	ПроверяемаяСхема = СхемыДанныхСпецификации.Получить(ИмяСхемы);

	Если Не ЗначениеЗаполнено(ПроверяемаяСхема) Тогда
		ВызватьИсключение "Схема не найдена";
	КонецЕсли;
	
	ПроверитьМодельДанныхПоСхеме(МодельДанных, ПроверяемаяСхема, СхемыДанныхСпецификации,,
	ОшибкиПроверкиМоделиДанныхПоСпецификации);
	
	Возврат ОшибкиПроверкиМоделиДанныхПоСпецификации;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверкиМоделей

Процедура ПроверитьМодельДанныхПоСхеме(Знач МодельДанных, Знач ПроверяемаяСхема, Знач СхемыДанных,
	Знач ПутьКСвойствам = "", Ошибки)
	
	КодОсновногоЯзыка = КодОсновногоЯзыка();
	ТипСхемы = ПроверяемаяСхема.Получить("type");
	
	Если ТипСхемы = ТипОбъектOpenAPI() Тогда
		ПроверитьМодельДанныхПоСхемеТипОбъект(МодельДанных, ПроверяемаяСхема, СхемыДанных, ПутьКСвойствам, Ошибки);
	ИначеЕсли ТипСхемы = ТипМассивOpenAPI() Тогда
		ПроверитьМодельДанныхПоСхемеТипМассив(МодельДанных, ПроверяемаяСхема, СхемыДанных, ПутьКСвойствам, Ошибки);
	Иначе
		ПроверитьМодельДанныхПоСхемеПримитивныйТип(МодельДанных, ПроверяемаяСхема, СхемыДанных, ПутьКСвойствам, Ошибки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьМодельДанныхПоСхемеТипОбъект(Знач МодельДанных, Знач ПроверяемаяСхема, Знач СхемыДанных,
	Знач ПутьКСвойствам = "", Ошибки)
	
	КодОсновногоЯзыка = КодОсновногоЯзыка();
	
	Если Не (ТипЗнч(МодельДанных) = Тип("Структура") ИЛИ ТипЗнч(МодельДанных) = Тип("Соответствие")) Тогда
		Ошибки.Добавить(НСтр("ru='Модель данных должна быть в формате объекта'"));
		Возврат;
	КонецЕсли;
	
	СвойстваПоСпецификации = ПроверяемаяСхема.Получить("properties");
	
	Если Не ЗначениеЗаполнено(СвойстваПоСпецификации) Тогда
		Возврат;
	КонецЕсли;
	
	ОбязательныеСвойства = ПроверяемаяСхема.Получить("required");
	ОбязательныеСвойства = ?(ОбязательныеСвойства = Неопределено, Новый Массив, ОбязательныеСвойства);
	
	Для Каждого СвойствоВТерминахСпецификации Из СвойстваПоСпецификации Цикл
		
		ПараметрыСвойства = СвойствоВТерминахСпецификации.Значение;
		
		СвойствоСхемы = СвойствоСхемыВТерминах1С(СвойствоВТерминахСпецификации,
		ОбязательныеСвойства, ПутьКСвойствам, МодельДанных, СхемыДанных);
		
		СвойствоЗаполнено = ЗначениеЗаполнено(СвойствоСхемы.ЗначениеСвойства);
		
		Если СвойствоСхемы.СвойствоОбязательное Тогда
			Если Не СвойствоСхемы.СвойствоОбъявлено  Тогда
				ПредставлениеОшибки = СтрШаблон(НСтр("ru = 'Отсутствует обязательное свойство ""%1"" (%2).'", КодОсновногоЯзыка),
				СвойствоСхемы.Путь, СвойствоСхемы.Описание);
				
				Ошибки.Добавить(ПредставлениеОшибки);
				Продолжить;
			ИначеЕсли Не СвойствоЗаполнено Тогда
				ПредставлениеОшибки = СтрШаблон(НСтр("ru = 'Не заполнено обязательное свойство ""%1"" (%2).'", КодОсновногоЯзыка),
				СвойствоСхемы.Путь, СвойствоСхемы.Описание);
				
				Ошибки.Добавить(ПредставлениеОшибки);
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если Не СвойствоСхемы.СвойствоОбъявлено Тогда
			Продолжить;
		КонецЕсли;
		
		Если СвойствоСхемы.Тип = Тип("Структура") Тогда
			
			ПроверитьМодельДанныхПоСхеме(СвойствоСхемы.ЗначениеСвойства, СвойствоСхемы.ВложеннаяСхема,
			СхемыДанных, СвойствоСхемы.Путь, Ошибки);
			
		ИначеЕсли СвойствоСхемы.Тип = Тип("Массив") Тогда
			
			ПроверитьТипМассивСвойстваМоделиДанных(СвойствоСхемы, ПараметрыСвойства, СхемыДанных, Ошибки);
			
		Иначе
			ПроверитьТипЗначенияСвойстваМоделиДанных(СвойствоСхемы, Ошибки);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьМодельДанныхПоСхемеТипМассив(Знач МодельДанных, Знач ПроверяемаяСхема, Знач СхемыДанных,
	Знач ПутьКСвойствам = "", Ошибки)
	
	КодОсновногоЯзыка = КодОсновногоЯзыка();
	
	Если Не ТипЗнч(МодельДанных) = Тип("Массив") Тогда
		Ошибки.Добавить(НСтр("ru='Модель данных должна быть в формате массива'"));
		Возврат;
	КонецЕсли;
	
	ВложеннаяСхема = ПроверяемаяСхема.Получить("items");
	
	Для Каждого ОбъектДанных Из МодельДанных Цикл
		ПроверитьМодельДанныхПоСхеме(ОбъектДанных, ВложеннаяСхема, СхемыДанных, ПутьКСвойствам, Ошибки);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьМодельДанныхПоСхемеПримитивныйТип(Знач МодельДанных, Знач ПроверяемаяСхема, Знач СхемыДанных,
	Знач ПутьКСвойствам = "", Ошибки)
	
	КодОсновногоЯзыка = КодОсновногоЯзыка();
	
	Тип = ТипСвойстваСхемыДанных(ПроверяемаяСхема);
	
	СвойствоСхемыВТерминах1С = НовоеСвойствоСхемыВТерминах1С();
	СвойствоСхемыВТерминах1С.Тип  = Тип;
	СвойствоСхемыВТерминах1С.Путь = ПутьКСвойствам;
	СвойствоСхемыВТерминах1С.ЗначениеСвойства = МодельДанных;
	СвойствоСхемыВТерминах1С.ЭтоСхемаПримитивногоТипа = Истина;
	
	ПроверитьТипЗначенияСвойстваМоделиДанных(СвойствоСхемыВТерминах1С, Ошибки);
	
КонецПроцедуры

#Область ПроверкиЗначенийСвойств

Процедура ПроверитьТипЗначенияСвойстваМоделиДанных(Знач СвойствоСхемы, Ошибки)
	
	ЭтоКорректныйТип = Истина;
	
	КодОсновногоЯзыка = КодОсновногоЯзыка();
	
	ЗначениеСвойства = СвойствоСхемы.ЗначениеСвойства;
	Путь             = СвойствоСхемы.Путь;
	ЭтоСхемаПримитивногоТипа = СвойствоСхемы.ЭтоСхемаПримитивногоТипа;
	
	ПриведенноеЗначениеСвойства = СвойствоСхемы.Тип.ПривестиЗначение(ЗначениеСвойства);
	
	Если ПриведенноеЗначениеСвойства <> ЗначениеСвойства Тогда
		
		РазличаютсяКвалификаторы = ТипЗнч(ПриведенноеЗначениеСвойства) = ТипЗнч(ЗначениеСвойства);
		
		Если РазличаютсяКвалификаторы Тогда
			
			Если ЭтоСхемаПримитивногоТипа Тогда
				Если Не СвойствоСхемы.Формат = Неопределено  Тогда
					ПредставлениеОшибки = СтрШаблон(
												НСтр("ru = 'Некорректный тип схемы. Ожидается тип ""%1"", с форматом ""%2"". См. Спецификацию.'",
						КодОсновногоЯзыка),	ТипЗнч(ПриведенноеЗначениеСвойства), СвойствоСхемы.Формат);
				Иначе
					ПредставлениеОшибки = НСтр("ru = 'Некорректный тип схемы. См. спецификацию.'",
					КодОсновногоЯзыка);
				КонецЕсли;

			Иначе
				СтрокаФормата = "";
				Если Не СвойствоСхемы.Формат = Неопределено  Тогда
					СтрокаФормата = СтрШаблон("Ожидается формат ""%1"".", СвойствоСхемы.Формат);
				КонецЕсли;
				
				ПредставлениеОшибки = СтрШаблон(НСтр("ru = 'Некорректный тип свойства ""%1"" (%2). %3См. спецификацию.'",
				КодОсновногоЯзыка), Путь, СвойствоСхемы.Описание,СтрокаФормата);
				
			КонецЕсли;
			
		Иначе
			
			ТипПриведенногоЗначения = ТипЗнч(ЗначениеСвойства);
			ОжидаемыйТип = ТипЗнч(ПриведенноеЗначениеСвойства);
			
			ПредставлениеОжидаемогоТипа = ?(СвойствоСхемы.Тип.СодержитТип(Тип("Структура")),
												НСтр("ru = 'Объект'"), ОжидаемыйТип);
			ПредставлениеПриведенногоЗначения = ?(ТипПриведенногоЗначения = Тип("Структура"),
													НСтр("ru = 'Объект'"), ТипПриведенногоЗначения);
			
			Если ЭтоСхемаПримитивногоТипа Тогда
				
				ПредставлениеОшибки = СтрШаблон(
									НСтр("ru = 'Некорректный тип схемы. Ожидается тип ""%1"", передан тип ""%2"".'", КодОсновногоЯзыка),
				ПредставлениеОжидаемогоТипа, ПредставлениеПриведенногоЗначения);
				
			Иначе
				
				ПредставлениеОшибки = СтрШаблон(
					НСтр("ru = 'Некорректный тип свойства ""%1"" (%2). Ожидается тип ""%3"", передан тип ""%4"".'", КодОсновногоЯзыка),
					Путь, СвойствоСхемы.Описание, ПредставлениеОжидаемогоТипа, ПредставлениеПриведенногоЗначения);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Ошибки.Добавить(ПредставлениеОшибки);
		
		ЭтоКорректныйТип = Ложь;
		
	КонецЕсли;
	
	ЭтоПеречисление = ЗначениеЗаполнено(СвойствоСхемы.ДопустимыеЗначения);
	
	Если ЭтоКорректныйТип И ЭтоПеречисление Тогда
		
		ЭтоКорректноеЗначениеПеречисления = СвойствоСхемы.ДопустимыеЗначения.Найти(ЗначениеСвойства) <> Неопределено;
		
		Если Не ЭтоКорректноеЗначениеПеречисления Тогда
			
			ПредставлениеДопустимыхЗначений = СтрСоединить(СвойствоСхемы.ДопустимыеЗначения, ", ");
			
			ПредставлениеОшибки = СтрШаблон(НСтр("ru = 'Некорректное значение свойства ""%1"" (%2). Возможные значения: %3.'",
			КодОсновногоЯзыка), Путь, СвойствоСхемы.Описание, ПредставлениеДопустимыхЗначений);
			
			Ошибки.Добавить(ПредставлениеОшибки);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПроверитьСтрокуНаСоответствиеФорматуИПаттерну(СвойствоСхемы, Ошибки);
КонецПроцедуры

Процедура ПроверитьТипМассивСвойстваМоделиДанных(Знач СвойствоСхемы, Знач ПараметрыСвойства, Знач СхемыДанных, Ошибки)
	
	ВложеннаяСхема = ПараметрыСвойства.Получить("items");
	
	СсылкаНаСхему = ВложеннаяСхема.Получить("$ref");
	
	Если ЗначениеЗаполнено(СсылкаНаСхему) Тогда
		ВложеннаяСхема = ВложеннаяСхемаПоСсылке(СсылкаНаСхему, СхемыДанных);
	КонецЕсли;
	
	ТипВложеннойСхемы = ВложеннаяСхема.Получить("type");
	Если ТипВложеннойСхемы = ТипОбъектOpenAPI() Тогда
		
		ИндексЭлемента = 0;
		
		Для Каждого ЭлементМассива Из СвойствоСхемы.ЗначениеСвойства Цикл
			
			ПроверитьМодельДанныхПоСхеме(ЭлементМассива, ВложеннаяСхема, СхемыДанных,
			СтрШаблон("%1[%2]", СвойствоСхемы.Путь, ИндексЭлемента), Ошибки);
			
			ИндексЭлемента = ИндексЭлемента + 1;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьСтрокуНаСоответствиеФорматуИПаттерну(Знач СвойствоСхемы, Ошибки)
	Если Не ТипЗнч(СвойствоСхемы.ЗначениеСвойства) = Тип("Строка") Тогда
		Возврат;
	КонецЕсли;
	ФорматЗначения = СвойствоСхемы.Формат;
	Паттерн = СвойствоСхемы.Паттерн;
// BSLLS:LineLength-off
	Если ФорматЗначения = "byte" Тогда
		ПроверитьBase64(СвойствоСхемы, Ошибки);
	ИначеЕсли ФорматЗначения = "date" ИЛИ ФорматЗначения = "date-time" Тогда
		ПроверитьДату(СвойствоСхемы, Ошибки);
	ИначеЕсли ФорматЗначения = "email" Тогда
		Паттерн = "^((?!\.)[\w\-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$";
	ИначеЕсли ФорматЗначения = "uuid" Тогда
		Паттерн = "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}";
	ИначеЕсли ФорматЗначения = "uri" Тогда
		Паттерн = "^(((ht|f)tp(s?)\:\/\/[0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*(:(0-9)*)*))?(\/?)(\{?)([a-zA-Z0-9\-\.\?\,\'\/\\\+\~\{\}\&%\$#_]*)?(\}?)(\/?)$"; // BSLLS:LineLength-off
	ИначеЕсли ФорматЗначения = "ipv4" Тогда
		Паттерн = "^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$";
	ИначеЕсли ФорматЗначения = "ipv6" Тогда
		Паттерн = "^([[:xdigit:]]{1,4}(?::[[:xdigit:]]{1,4}){7}|::|:(?::[[:xdigit:]]{1,4}){1,6}|[[:xdigit:]]{1,4}:(?::[[:xdigit:]]{1,4}){1,5}|(?:[[:xdigit:]]{1,4}:){2}(?::[[:xdigit:]]{1,4}){1,4}|(?:[[:xdigit:]]{1,4}:){3}(?::[[:xdigit:]]{1,4}){1,3}|(?:[[:xdigit:]]{1,4}:){4}(?::[[:xdigit:]]{1,4}){1,2}|(?:[[:xdigit:]]{1,4}:){5}:[[:xdigit:]]{1,4}|(?:[[:xdigit:]]{1,4}:){1,6}:)$";
	Иначе
		ФорматЗначения = "pattern";
	КонецЕсли;
// BSLLS:LineLength-on
	Если ЗначениеЗаполнено(Паттерн) Тогда
		ПроверитьПоРегулярномуВыражению(СвойствоСхемы, Паттерн, Ошибки, ФорматЗначения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДату(СвойствоСхемы, Ошибки)
	Если СвойствоСхемы.Формат = "date" Тогда
		ОписаниеЧастиДаты = ЧастиДаты.Дата;
	Иначе
		ОписаниеЧастиДаты = ЧастиДаты.ДатаВремя;
	КонецЕсли;
	ОписаниеДаты = Новый ОписаниеТипов("Дата", , , , ,Новый КвалификаторыДаты(ОписаниеЧастиДаты));
	Попытка
		Дата = ПрочитатьДатуJSON(СвойствоСхемы.ЗначениеСвойства, ФорматДатыJSON.ISO);
		ПриведеннаяДата = ОписаниеДаты.ПривестиЗначение(Дата);
	Исключение
		// Не удалось прочитать дату, а значит там что-то некорректное.
        Дата = Истина;
		ПриведеннаяДата = Ложь;
	КонецПопытки;
	
	Если Не Дата = ПриведеннаяДата Тогда
		ПредставлениеОшибки = СтрШаблон(НСтр("ru = 'Некорректное значение свойства ""%1"" (%2). Ожидался формат %3'",
			КодОсновногоЯзыка()), СвойствоСхемы.Путь, СвойствоСхемы.Описание, СвойствоСхемы.Формат);
			Ошибки.Добавить(ПредставлениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьПоРегулярномуВыражению(СвойствоСхемы, Паттерн, Ошибки, Формат ="")
	Если Не СтрПодобнаПоРегулярномуВыражению(СвойствоСхемы.ЗначениеСвойства, Паттерн) Тогда
			ПредставлениеОшибки = СтрШаблон(НСтр("ru = 'Некорректное значение свойства ""%1"" (%2). Ожидался %3.'",
			КодОсновногоЯзыка()), СвойствоСхемы.Путь, СвойствоСхемы.Описание, Формат);
			Ошибки.Добавить(ПредставлениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьBase64(СвойствоСхемы, Ошибки)
		Если Не ЗначениеЗаполнено(Base64Значение(СвойствоСхемы.ЗначениеСвойства)) Тогда
			ПредставлениеОшибки = СтрШаблон(НСтр("ru = 'Некорректное значение свойства ""%1"" (%2). Ожидалось Base64 значение.'",
			КодОсновногоЯзыка()), СвойствоСхемы.Путь, СвойствоСхемы.Описание);
			
			Ошибки.Добавить(ПредставлениеОшибки);
		КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СвойствоСхемы

Функция НовоеСвойствоСхемыВТерминах1С()
	
	НовоеСвойствоСхемыВТерминах1С = Новый Структура;
	
	НовоеСвойствоСхемыВТерминах1С.Вставить("Имя");
	НовоеСвойствоСхемыВТерминах1С.Вставить("Тип");
	НовоеСвойствоСхемыВТерминах1С.Вставить("Описание");
	НовоеСвойствоСхемыВТерминах1С.Вставить("Путь");
	НовоеСвойствоСхемыВТерминах1С.Вставить("ВложеннаяСхема");
	НовоеСвойствоСхемыВТерминах1С.Вставить("ДопустимыеЗначения");
	НовоеСвойствоСхемыВТерминах1С.Вставить("СвойствоОбъявлено");
	НовоеСвойствоСхемыВТерминах1С.Вставить("СвойствоОбязательное");
	НовоеСвойствоСхемыВТерминах1С.Вставить("ЗначениеСвойства");
	НовоеСвойствоСхемыВТерминах1С.Вставить("ЭтоСхемаПримитивногоТипа", Ложь);
	НовоеСвойствоСхемыВТерминах1С.Вставить("Формат");
	НовоеСвойствоСхемыВТерминах1С.Вставить("Паттерн");
	
	Возврат НовоеСвойствоСхемыВТерминах1С;
	
КонецФункции

Функция СвойствоСхемыВТерминах1С(Знач СвойствоВТерминахСпецификации, Знач ОбязательныеСвойства,
	Знач ПутьКСвойствам, Знач МодельДанных, Знач СхемыДанных)
	
	СвойствоСхемыВТерминах1С = НовоеСвойствоСхемыВТерминах1С();
	
	ИмяСвойства   = СвойствоВТерминахСпецификации.Ключ;
	СсылкаНаСхему = СвойствоВТерминахСпецификации.Значение.Получить("$ref");
	
	Если ЗначениеЗаполнено(СсылкаНаСхему) Тогда
		ПараметрыСвойства = ВложеннаяСхемаПоСсылке(СсылкаНаСхему, СхемыДанных);
	Иначе
		ПараметрыСвойства = СвойствоВТерминахСпецификации.Значение;
	КонецЕсли;
	
	Тип = ТипСвойстваСхемыДанных(ПараметрыСвойства);
	
	СвойствоОбъявлено    = ?(ТипЗнч(МодельДанных) = тип("Структура"),
								МодельДанных.Свойство(ИмяСвойства),
								НЕ МодельДанных.Получить(ИмяСвойства) = Неопределено);
	СвойствоОбязательное = Не ОбязательныеСвойства.Найти(ИмяСвойства) = Неопределено;
	Описание             = ПараметрыСвойства.Получить("description");
	ДопустимыеЗначения   = ПараметрыСвойства.Получить("enum");
	ФорматЗначения		 = ПараметрыСвойства.Получить("format");
	Паттерн				 = ПараметрыСвойства.Получить("pattern");
	
	Если ЗначениеЗаполнено(ПутьКСвойствам) Тогда
		ПолныйПутьКСвойству = СтрШаблон("%1.%2", ПутьКСвойствам, ИмяСвойства);
	Иначе
		ПолныйПутьКСвойству = ИмяСвойства;
	КонецЕсли;
	
	СвойствоСхемыВТерминах1С.Имя 					= ИмяСвойства;
	СвойствоСхемыВТерминах1С.Тип					= Тип;
	СвойствоСхемыВТерминах1С.Описание				= Описание;
	СвойствоСхемыВТерминах1С.Путь					= ПолныйПутьКСвойству;
	СвойствоСхемыВТерминах1С.ВложеннаяСхема			= ПараметрыСвойства;
	СвойствоСхемыВТерминах1С.ДопустимыеЗначения		= ДопустимыеЗначения;
	СвойствоСхемыВТерминах1С.СвойствоОбъявлено	 	= СвойствоОбъявлено;
	СвойствоСхемыВТерминах1С.СвойствоОбязательное	= СвойствоОбязательное;
	СвойствоСхемыВТерминах1С.ЗначениеСвойства		= СвойствоСтруктуры(МодельДанных, ИмяСвойства);
	СвойствоСхемыВТерминах1С.Формат					= ФорматЗначения;
	СвойствоСхемыВТерминах1С.Паттерн				= Паттерн;
	
	Возврат СвойствоСхемыВТерминах1С;
	
КонецФункции

Функция ТипСвойстваСхемыДанных(Знач Свойство)
	
	ТипСвойстваСхемыДанных = Неопределено;
	
	ТипИзСпецификации = Свойство.Получить("type");
	ФорматЗначения = Свойство.Получить("format");
	
	ЧисловыеТипыOpenAPI = ЧисловыеТипыOpenAPI();
	ЭтоТипЧисло = Не ЧисловыеТипыOpenAPI.Найти(ТипИзСпецификации) = Неопределено;

	Если ТипИзСпецификации = ТипОбъектOpenAPI() Тогда
		ТипСвойстваСхемыДанных = Тип("Структура");
	ИначеЕсли ТипИзСпецификации = ТипМассивOpenAPI() Тогда
		ТипСвойстваСхемыДанных = Тип("Массив");
	ИначеЕсли ТипИзСпецификации = ТипСтрокаOpenAPI() Тогда
		ТипСвойстваСхемыДанных = Новый ОписаниеТипов("Строка");
		Если ФорматЗначения = "date" Тогда
			ТипСвойстваСхемыДанных = Новый ОписаниеТипов(ТипСвойстваСхемыДанных,
															"Дата", , , , Новый КвалификаторыДаты(ЧастиДаты.Дата));
		КонецЕсли;
		Если ФорматЗначения = "date-time" Тогда
			ТипСвойстваСхемыДанных = Новый ОписаниеТипов(ТипСвойстваСхемыДанных,
															"Дата", , , , Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя));
		КонецЕсли;
	ИначеЕсли ЭтоТипЧисло Тогда
		ТипСвойстваСхемыДанных = Новый ОписаниеТипов("Число");
	ИначеЕсли ТипИзСпецификации = ТипБулевоOpenAPI() Тогда
		ТипСвойстваСхемыДанных = Новый ОписаниеТипов("Булево");
	КонецЕсли;
	
	Возврат ТипСвойстваСхемыДанных;
	
КонецФункции

Функция ВложеннаяСхемаПоСсылке(Знач Ссылка, Знач СхемыДанных)
	
	ВложеннаяСхемаПоСсылке = Неопределено;
	
	ИмяСхемы = СтрЗаменить(Ссылка, "#/components/schemas/","");
	ВложеннаяСхемаПоСсылке = СхемыДанных.Получить(ИмяСхемы);
	
	Возврат ВложеннаяСхемаПоСсылке;
	
КонецФункции

#КонецОбласти

#Область ТипыOpenAPI

Функция ТипОбъектOpenAPI()
	
	Возврат "object";
	
КонецФункции

Функция ТипМассивOpenAPI()
	
	Возврат "array";
	
КонецФункции

Функция ТипСтрокаOpenAPI()
	
	Возврат "string";
	
КонецФункции

Функция ЧисловыеТипыOpenAPI()
	
	ЧисловыеТипыOpenAPI = Новый Массив;
	ЧисловыеТипыOpenAPI.Добавить("integer");
	ЧисловыеТипыOpenAPI.Добавить("number");
	
	Возврат ЧисловыеТипыOpenAPI;
	
КонецФункции

Функция ТипБулевоOpenAPI()
	
	Возврат "boolean";
	
КонецФункции

#КонецОбласти

#Область ОписаниеТипов

// Создает объект ОписаниеТипов, содержащий тип Строка.
//
// Параметры:
//  ДлинаСтроки - Число - длина строки.
//
// Возвращаемое значение:
//  ОписаниеТипов - описание типа Строка.
//
Функция ОписаниеТипаСтрока(ДлинаСтроки)
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));
	
	КвалификаторСтроки = Новый КвалификаторыСтроки(ДлинаСтроки, ДопустимаяДлина.Переменная);
	
	Возврат Новый ОписаниеТипов(Массив, , КвалификаторСтроки);
	
КонецФункции

// Создает объект ОписаниеТипов, содержащий тип Число.
//
// Параметры:
//  Разрядность - Число - общее количество разрядов числа (количество разрядов
//                        целой части плюс количество разрядов дробной части).
//  РазрядностьДробнойЧасти - Число - число разрядов дробной части.
//  ЗнакЧисла - ДопустимыйЗнак - допустимый знак числа.
//
// Возвращаемое значение:
//  ОписаниеТипов - описание типа Число.
Функция ОписаниеТипаЧисло(Разрядность, РазрядностьДробнойЧасти = 0, ЗнакЧисла = Неопределено)
	
	Если ЗнакЧисла = Неопределено Тогда
		КвалификаторЧисла = Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти);
	Иначе
		КвалификаторЧисла = Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти, ЗнакЧисла);
	КонецЕсли;
	
	Возврат Новый ОписаниеТипов("Число", КвалификаторЧисла);
	
КонецФункции

// Создает объект ОписаниеТипов, содержащий тип Дата.
//
// Параметры:
//  ЧастиДаты - ЧастиДаты - набор вариантов использования значений типа Дата.
//
// Возвращаемое значение:
//  ОписаниеТипов - описание типа Дата.
Функция ОписаниеТипаДата(ЧастиДаты)
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("Дата"));
	
	КвалификаторДаты = Новый КвалификаторыДаты(ЧастиДаты);
	
	Возврат Новый ОписаниеТипов(Массив, , , КвалификаторДаты);
	
КонецФункции

#КонецОбласти

#Область ОбщегоНазначения

Функция КодОсновногоЯзыка() Экспорт
	
	Возврат "ru";
	
КонецФункции

// Возвращает значение свойства структуры.
//
// Параметры:
//   Структура - Структура, ФиксированнаяСтруктура - Объект, из которого необходимо прочитать значение ключа.
//   Ключ - Строка - Имя свойства структуры, для которого необходимо прочитать значение.
//   ЗначениеПоУмолчанию - Произвольный - Необязательный. Возвращается когда в структуре нет значения по указанному
//                                        ключу.
//       Для скорости рекомендуется передавать только быстро вычисляемые значения (например примитивные типы),
//       а инициализацию более тяжелых значений выполнять после проверки полученного значения (только если это
//       требуется).
//
// Возвращаемое значение:
//   Произвольный - Значение свойства структуры. ЗначениеПоУмолчанию если в структуре нет указанного свойства.
//
Функция СвойствоСтруктуры(Структура, Ключ, ЗначениеПоУмолчанию = Неопределено)
	
	Если Структура = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Неопределено;
	Если ТипЗнч(Структура) = Тип("Структура") Тогда
		Структура.Свойство(Ключ, Результат)
	Иначе
		Результат = Структура.Получить(Ключ);
	КонецЕсли;
	
	Возврат ?(Результат=Неопределено, ЗначениеПоУмолчанию, Результат);

КонецФункции

#КонецОбласти

#КонецОбласти
