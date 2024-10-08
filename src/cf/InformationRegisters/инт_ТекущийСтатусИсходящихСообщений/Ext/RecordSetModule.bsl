﻿
////////////////////////////////////////////////////////////////////////////////

// <Заголовок модуля: краткое описание и условия применения модуля.>

//  

////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписью(Отказ, Замещение)
    Для Каждого Запись Из ЭтотОбъект Цикл
        Если Перечисления.инт_СтатусыИсходящихСообщений.ЭтоОшибочныйСтатус(Запись.СтатусСообщения)
            И Не ЗначениеЗаполнено(Запись.ТекстОшибки) Тогда
            ВызватьИсключение "При попытке зафиксировать ошибочный статус - не заполнен текст ошибки!";
        КонецЕсли;
    КонецЦикла;
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
    Для Каждого Запись Из ЭтотОбъект Цикл
        РегистрыСведений.инт_ИсторияСтатусовИсходящихСообщений.ЗаписатьСтатусВИсторию(Запись.ИдентификаторСообщения,
                                                                                        Запись.СтатусСообщения,
                                                                                        Запись.ТекстОшибки);
    КонецЦикла;
 
КонецПроцедуры

#КонецОбласти

