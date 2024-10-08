﻿#Область ПрограммныйИнтерфейс

// Возвращает префикс объектов расширения
// Возвращаемое значение:
//   Строка	- Префикс объектов расширения
Функция Префикс() Экспорт
	
	Возврат "ИТКВ_";
	
КонецФункции

// Возвращает идентификатор расширения
//
// Возвращаемое значение:
//   Строка	- Идентификатор расширения
//
Функция Идентификатор() Экспорт
	
	Возврат "InfostartToolkitPROF";
	
КонецФункции

Функция Представление() Экспорт
	
	Возврат НСтр("ru = 'Infostart Toolkit PROF'; en = 'Infostart Toolkit PROF'");
	
КонецФункции

// Возвращает полное имя расширения
//
// Возвращаемое значение:
//   Строка	- полное имя расширения
//
Функция ПолноеПредставление() Экспорт
	
	Версия = ИТКВ_ТуллкитКлиентСерверПовтИсп.Версия();
	Возврат СтрШаблон("%1 %2", Представление(), Версия);
	
КонецФункции

Функция ЖурналРегистрацииПредставление() Экспорт
	
	Возврат НСтр("ru = 'Журнал регистрации'; en = 'Event log'");
	
КонецФункции

Функция КонструкторСКДПредставление() Экспорт
	
	Возврат НСтр("ru = 'Конструктор схемы компоновки данных'; en = 'Data composition schema designer'");
	
КонецФункции

// Возвращает имя события журнала регистрации
//
// Возвращаемое значение:
//   Строка	- имя события журнала регистрации
//
Функция ИмяСобытияЖурналаРегистрации() Экспорт
	
	Возврат ИТКВ_ТуллкитКлиентСервер.Представление();
	
КонецФункции

Функция ОграниченнаяВерсия() Экспорт
	
	Результат = СтрЗаканчиваетсяНа(ИТКВ_ТуллкитКлиентСервер.Идентификатор(), "ADMIN");
	Возврат Результат;
	
КонецФункции

Функция ПолнаяВерсия() Экспорт
	
	Результат = НЕ ОграниченнаяВерсия();
	Возврат Результат;
	
КонецФункции

Функция КартинкаИнструмента(Инструмент) Экспорт
	
	Если Инструмент = ИТКВ_Перечисления.ИнструментПодпискиНаСобытия() Тогда
		
		Результат = БиблиотекаКартинок.ИТКВ_ПодпискаНаСобытие;
		
	ИначеЕсли Инструмент = ИТКВ_Перечисления.ИнструментЖурналРегистрации() Тогда
		
		Результат = БиблиотекаКартинок.ЖурналРегистрации;
		
	ИначеЕсли Инструмент = ИТКВ_Перечисления.ИнструментРегламентныеИФоновыеЗадания() Тогда
		
		Результат = БиблиотекаКартинок.РегламентныеЗадания;
		
	ИначеЕсли Инструмент = ИТКВ_Перечисления.ИнструментПользователи() Тогда
		
		Результат = БиблиотекаКартинок.Пользователь;
		
	ИначеЕсли Инструмент = ИТКВ_Перечисления.ИнструментОткрытьОбъект() Тогда
		
		Результат = БиблиотекаКартинок.ПоказатьДанные;
		
	Иначе
		
		Результат = БиблиотекаКартинок.Форма;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
