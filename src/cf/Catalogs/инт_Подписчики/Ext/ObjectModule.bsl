﻿////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

    Если ТипПодписчика = Перечисления.инт_ТипыПодписчиков.ПроизвольныйHTTP Тогда
    	ПроверяемыеРеквизиты.Добавить("СпособПередачиИдентификатораСообщения");
        ПроверяемыеРеквизиты.Добавить("СпособПередачиИдентификатораПотока");
    КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

