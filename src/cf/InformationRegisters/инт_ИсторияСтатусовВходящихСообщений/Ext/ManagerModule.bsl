﻿////////////////////////////////////////////////////////////////////////////////

// инт_ИсторияСтатусовИсходящихСообщений

//  

////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура - Записать статус в историю
// Если статусов больше чем 1 в секунду - такая история не хранится.
// Параметры:
//  ИдентификаторСообщения     -  УникальныйИдентификатор  - Уникальный идентификатор сообщения
//  Статус                     -  ПеречислениеСсылка.инт_СтатусыВходящихСообщений  -  Статус сообщения.
//  ТекстОшибки                -  Строка    - Текст ошибки при формировании сообщения 
//
Процедура ЗаписатьСтатусВИсторию(ИдентификаторСообщения, СтатусСообщения, ТекстОшибки="") экспорт
    Запись = РегистрыСведений.инт_ИсторияСтатусовВходящихСообщений.СоздатьМенеджерЗаписи();
    Запись.Период = ТекущаяДатаСеанса();
    Запись.ИдентификаторСообщения = ИдентификаторСообщения;
    Запись.СтатусСообщения = СтатусСообщения;
    Запись.ТекстОшибки = ТекстОшибки;
    Запись.Записать(Истина);
КонецПроцедуры

// Процедура - Очистить историю по идентификатору
// Очищает историю статусов по переданному идентификатору сообщения
// Параметры:
//  ИдентификаторСообщения     -  УникальныйИдентификатор  - Уникальный идентификатор сообщения
//
Процедура ОчиститьИсториюПоИдентификатору(ИдентификаторСообщения) Экспорт
	Набор = РегистрыСведений.инт_ИсторияСтатусовВходящихСообщений.СоздатьНаборЗаписей();
	Набор.Отбор.ИдентификаторСообщения.Установить(ИдентификаторСообщения);
	Набор.Записать();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли
