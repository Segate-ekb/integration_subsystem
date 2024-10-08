﻿#Область ПрограммныйИнтерфейс

// Обновляет заголовок формы
//
// Параметры:
//  Форма - Форма - Форма
//  Заголовок - Строка - Заголовок формы
//  Дополнение - Булево - Дополнять заголовок названием расширения
//
Процедура Заголовок(Форма, Заголовок, Дополнение = Ложь) Экспорт
	
	НовыйЗаголовок = Заголовок;
	
	Если Дополнение Тогда
		НовыйЗаголовок = НовыйЗаголовок + " : " + ИТКВ_КонсольРазработчикаКлиентСервер.Представление();
	КонецЕсли;
	
	Форма.Заголовок = НовыйЗаголовок;
	
КонецПроцедуры

Функция НеобходимоРазвернутьСтроку(Строка, ПроверяемоеПоле = "Представление") Экспорт
	
	Если Строка = Неопределено Тогда
		
		Результат = Ложь;
		
	Иначе
		
		Строки = Строка.ПолучитьЭлементы();
		Результат = ЗначениеЗаполнено(Строки) И Не ЗначениеЗаполнено(Строки[0][ПроверяемоеПоле]);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Устанавливает заголовок формы
//
// Параметры:
//  Форма - Форма - Форма
//  Заголовок - Строка - Заголовок формы
//  Дополнение - Строка - Дополнение заголовка
//
Процедура УстановитьЗаголовок(Форма, Заголовок, Дополнение = "") Экспорт
	
	Если ЗначениеЗаполнено(Дополнение) Тогда
		
		Заголовок = СтрШаблон("%1 : %2", Заголовок, Дополнение);
		
	КонецЕсли;
	
	Форма.Заголовок = Заголовок;
	
КонецПроцедуры

Функция ЗаголовокСКоличеством(Заголовок, Количество) Экспорт
	
	Результат = Заголовок;
	
	Если ЗначениеЗаполнено(Количество) Тогда
		
		Результат = СтрШаблон("%1 (%2)", Результат, Формат(Количество, "ЧГ="));
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЗаголовокСРасшифровкой(Заголовок, Расшифровка) Экспорт
	
	Результат = Заголовок;
	
	Если ЗначениеЗаполнено(Расшифровка) Тогда
		
		Результат = СтрШаблон("%1 - %2", Результат, Расшифровка);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ФорматРедактированияДаты(ОписаниеТипов) Экспорт
	
	Если ИТКВ_ТипыКлиентСервер.Количество(ОписаниеТипов) <> 1 Тогда
		
		Возврат "";
		
	КонецЕсли;
	
	КвалификаторыЧастиДаты = ОписаниеТипов.КвалификаторыДаты.ЧастиДаты;
	
	Если КвалификаторыЧастиДаты = ЧастиДаты.Время Тогда
		
		Результат = "ДЛФ=T";
		
	ИначеЕсли КвалификаторыЧастиДаты = ЧастиДаты.Дата Тогда
		
		Результат = "ДЛФ=D";
		
	Иначе
		
		Результат = "";
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура СкрытьГруппу(Элемент) Экспорт
	
	Если ИТКВ_ОбщийКлиентСервер.ПоддерживаетсяПлатформой("8.3.12") Тогда
		
		Элемент.Скрыть();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьГруппу(Элемент) Экспорт
	
	Если ИТКВ_ОбщийКлиентСервер.ПоддерживаетсяПлатформой("8.3.12") Тогда
		
		Элемент.Показать();
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПредставлениеОтбораСписком(Список, Длина = 100, Разделитель = ", ") Экспорт
	
	Если НЕ ЗначениеЗаполнено(Список) Тогда
		Возврат НСтр("ru = 'Все'; en = 'All'");
	КонецЕсли;
	
	Результат = "";
	СписокЗначенийСтрокой = (ТипЗнч(Список) = Тип("Строка"));
	
	Если СписокЗначенийСтрокой Тогда
		Элементы = СтрРазделить(Список, Разделитель, Ложь);
	Иначе
		Элементы = Список;
	КонецЕсли;
	
	// Собираем элементы
	Для Каждого Элемент Из Элементы Цикл
		
		// Добавление разделителя
		Если ЗначениеЗаполнено(Результат) Тогда
			
			Результат = Результат + Разделитель;
			
		КонецЕсли;
		
		// Добавление элемента
		Если СписокЗначенийСтрокой Тогда
			Представление = Элемент;
		Иначе
			
			Если ЗначениеЗаполнено(Элемент.Представление) Тогда
				Представление = Элемент.Представление;
			Иначе
				Представление = Элемент.Значение;
			КонецЕсли;
			
		КонецЕсли;
		
		Результат = Результат + Элемент;
		
		// Анализ максимальной длины
		Если СтрДлина(Результат) > Длина Тогда
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Добавлем суффикс
	Количество = ИТКВ_Строки.ЧислоВСтроку(Элементы.Количество());
	СуффиксКоличество = СтрШаблон(" (%1)", Количество);
	
	Если СтрДлина(Результат) > Длина Тогда
		
		СуффиксКоличество = ".." + СуффиксКоличество;
		Результат = Лев(Результат, Длина - СтрДлина(СуффиксКоличество));
		
	КонецЕсли;
	
	Результат = Результат + СуффиксКоличество;
	
	Возврат Результат;
	
КонецФункции

Функция ВыбранОбъект(Объект) Экспорт
	
	Возврат ТипЗнч(Объект) <> Тип("Строка")
				И ЗначениеЗаполнено(Объект);
	
КонецФункции

Функция ВыбранТипОбъекта(Объект) Экспорт
	
	Возврат НЕ (ТипЗнч(Объект) = Тип("Строка")
					ИЛИ Объект = Неопределено);
	
КонецФункции

Процедура ОтображатьСтрокуПоискаТаблицыФормы(Элемент, ПоложениеПоиска = Неопределено) Экспорт
	
	Если ПоложениеПоиска = Неопределено Тогда
		ПоложениеПоиска = ПоложениеСтрокиПоиска.Верх;
	КонецЕсли;
	
	Если ИТКВ_ОбщийКлиентСервер.ПоддерживаетсяПлатформой("8.3.16") Тогда
		
		Элемент.ПоложениеСтрокиПоиска = ПоложениеПоиска;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОшибкиНастроекОтчетаИмяОсновногоРеквизита() Экспорт
	
	Возврат "ОшибкиНастроекОтчета";
	
КонецФункции

Процедура ОтображениеСостоянияТабличногоДокумента(Элемент, Текст = Неопределено, Картинка = Неопределено) Экспорт
	
	ОтображениеСостоянияИдетПоискСсылок = Элемент.ОтображениеСостояния;
	ОтображениеСостоянияИдетПоискСсылок.Видимость = Истина;
	ОтображениеСостоянияИдетПоискСсылок.Текст = Текст;
	
	Если Картинка = Неопределено Тогда
		Картинка = БиблиотекаКартинок.ИТКВ_ДлительнаяОперацияАнимация48;
	КонецЕсли;
	
	ОтображениеСостоянияИдетПоискСсылок.Картинка = Картинка;
	
КонецПроцедуры

Функция ГруппировкаПодчиненныхЭлементовГоризонтальная() Экспорт
	
	Если ИТКВ_ОбщийКлиентСервер.ПоддерживаетсяПлатформой("8.3.12") Тогда
		ИмяПеречисления = "ГоризонтальнаяВсегда";
	Иначе
		ИмяПеречисления = "Горизонтальная";
	КонецЕсли;
	
	Возврат Вычислить("ГруппировкаПодчиненныхЭлементовФормы." + ИмяПеречисления);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти
