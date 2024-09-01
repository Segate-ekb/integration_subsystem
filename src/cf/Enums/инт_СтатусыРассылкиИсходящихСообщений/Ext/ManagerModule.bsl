﻿////////////////////////////////////////////////////////////////////////////////

// инт_СтатусыИсходящихСообщений

//  

////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция - Это ошибочный статус
//
// Параметры:
//  Статус     -  ПеречислениеСсылка.инт_СтатусыИсходящихСообщений -  Ссылка на проверяемый статус.
// 
// Возвращаемое значение:
//  Булево - Истина, если статус относится к ошибочным и Ложь, если нет. 
//
Функция ЭтоОшибочныйСтатус(Статус) Экспорт
	МассивОшибочныхСтатусов = Новый Массив;
    МассивОшибочныхСтатусов.Добавить(Перечисления.инт_СтатусыРассылкиИсходящихСообщений.ОшибкаОбработки);
    Возврат Не МассивОшибочныхСтатусов.Найти(Статус) = Неопределено;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли
