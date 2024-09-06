﻿////////////////////////////////////////////////////////////////////////////////

// инт_МенеджерПотоковОтправкиСообщений

//  

////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура - Собрать мусор
// 
// Процедура выполняет анализ содержимого регистра. Для каждого из существующих потоков проверяется его состояние. 
// Если поток не активен, но не удалился автоматически - он признается проблемным.
// Для проблемных потоков производится анализ сообщений. Если есть сообщения не обработанные потоком, то они возвращаются в общий пул сообщений к обработке. 
Процедура СобратьМусор() Экспорт
 	Выборка = РегистрыСведений.инт_МенеджерПотоковОтправкиСообщений.Выбрать();
    
    Пока Выборка.Следующий() Цикл
    	Поток = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Выборка.ИдентификаторПотока);
        Если Поток = Неопределено ИЛИ Не Поток.Состояние = СостояниеФоновогоЗадания.Активно Тогда
        	ОбработатьОткатПотока(Выборка.ИдентификаторПотока, Выборка.СоставПотока);
        КонецЕсли;
    КонецЦикла;
КонецПроцедуры

// Процедура - Зарегистрировать поток
//
// Параметры:
//  ИдентификаторПотока     -   УникальныйИдентификатор   - Идентификатор фонового задания, реализующего поток.
//  МассивОбъектов         -   Массив   - Массив структур <ИдентификаторСообщения,Подписчик> обрабатываемых в потоке
//
Процедура ЗарегистрироватьПоток(ИдентификаторПотока, ТипПодписчика = Неопределено, МассивОбъектов) Экспорт
    Если ТипПодписчика = Неопределено Тогда
        ТипПодписчика = Перечисления.инт_ТипыПодписчиков.ПустаяСсылка();
    КонецЕсли;
	СоставПотока = инт_КоннекторHTTP.ОбъектВJson(МассивОбъектов);
    Запись = РегистрыСведений.инт_МенеджерПотоковОтправкиСообщений.СоздатьМенеджерЗаписи();
    Запись.ИдентификаторПотока = ИдентификаторПотока;
    Запись.СоставПотока = СоставПотока;
    Запись.Записать();
    
КонецПроцедуры

Процедура ОбработатьЗавершениеРаботыПотока(ИдентификаторПотока) Экспорт
    ТекстСообщенияЖР = СтрШаблон("Поток с идентификатором <%1> успешно завершен", ИдентификаторПотока);
	УдалитьПотокИзМенеджера(ИдентификаторПотока);
    ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.МенеджерПотоковФормированияСообщений", УровеньЖурналаРегистрации.Информация,,,ТекстСообщенияЖР);
КонецПроцедуры

// Функция - Количество потоков к созданию
// 
// Возвращаемое значение:
// Число  - Количество потоков которое можно еще создать в системе.
//
Функция КоличествоПотоковКСозданию(ТипПодписчика = Неопределено) Экспорт
    Если ТипПодписчика = Неопределено Тогда
        ТипПодписчика = Перечисления.инт_ТипыПодписчиков.ПустаяСсылка();
    КонецЕсли;
	МаксимальноеКоличествоПотоков= инт_ОтправкаИсходящихСообщенийПовтИсп.КоличествоПотоковОтправкиСообщений();
    Запрос = Новый Запрос;
    Запрос.Текст = "ВЫБРАТЬ
                   |    КОЛИЧЕСТВО(РАЗЛИЧНЫЕ инт_МенеджерПотоковОтправкиСообщений.ИдентификаторПотока) КАК КоличествоПотоков
                   |ИЗ
                   |    РегистрСведений.инт_МенеджерПотоковОтправкиСообщений КАК инт_МенеджерПотоковОтправкиСообщений
                   |ГДЕ
                   |    инт_МенеджерПотоковОтправкиСообщений.ТипПодписчиков = &ТипПодписчиков";
    Запрос.УстановитьПараметр("ТипПодписчиков", ТипПодписчика);
    Выборка = Запрос.Выполнить().Выбрать();
    Если Выборка.Следующий() Тогда
    	КоличествоПотоков = Выборка.КоличествоПотоков;
    КонецЕсли;
    
    Возврат ?(КоличествоПотоков >= МаксимальноеКоличествоПотоков, 0, МаксимальноеКоличествоПотоков-КоличествоПотоков);
КонецФункции
 
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура ОбработатьОткатПотока(ИдентификаторПотока, СоставПотока)
    НачатьТранзакцию();
    Попытка
        Поток = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторПотока);
        Если Поток = Неопределено Тогда
            СообщениеОбОшибке = СтрШаблон("Поток с идентификатором <%1> не найден в списке фоновых заданий. Будет выполнен откат состава потока.",
            ИдентификаторПотока);
        Иначе
            СообщениеОбОшибке = СтрШаблон("Поток с идентификатором <%1> завершился не штатно.
            |
            |Состояние потока: %2
            |ИнформацияОбОшибке(Если есть): %3",
            Поток.УникальныйИдентификатор,
            Поток.Состояние,
            ПодробноеПредставлениеОшибки(Поток.ИнформацияОбОшибке));
        КонецЕсли;
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.МенеджерПотоковФормированияСообщений",УровеньЖурналаРегистрации.Ошибка, ,,СообщениеОбОшибке);
        
        УдалитьПотокИзМенеджера(ИдентификаторПотока);
        
        ОбработатьОткатСтатусаСообщений(СоставПотока);
         
        ЗафиксироватьТранзакцию();
    Исключение
        ОтменитьТранзакцию();
        СообщениеОбОшибке = СтрШаблон("При попытке обработки потока завершившегося с ошибкой с идентификатором <%1>, возникла ошибка.
        |
        | Информация об ошибке: %2", ИдентификаторПотока, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.МенеджерПотоковФормированияСообщений",УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
    КонецПопытки;
		
КонецПроцедуры

Процедура ОбработатьОткатСтатусаСообщений(СоставПотока)
    МассивСообщений = инт_КоннекторHTTP.JsonВОбъект(СоставПотока);
    
    Для Каждого Сообщение Из МассивСообщений Цикл
        ИдентификаторСообщения = Новый УникальныйИдентификатор(Сообщение.ИдентификаторСообщения);
        Подписчик = Справочники.инт_Подписчики.ПолучитьСсылку(Новый УникальныйИдентификатор(Сообщение.Подписчик));
        Статус = РегистрыСведений.инт_ТекущийСтатусРассылкиСообщений.ТекущийСтатусСообщения(ИдентификаторСообщения, Сообщение.Подписчик);
        // Если статус "ВПроцессеОтправки" значит Фоновое по какой-то причине упало раньше, чем обработало это сообщение.Вернем его в пул сообщений к формированию.
        Если Статус = Перечисления.инт_СтатусыРассылкиИсходящихСообщений.ВПроцессеОтправки Тогда
            // Возможно, что когда-нибудь потом мы начнем отслеживать падения и так же убирать из пула сообщения, которые приводят к падению через попытки. но потом.
            ТекстСообщенияЖР = СтрШаблон("Сообщение с идентификатором <%1> попало в поток который завершился аварийно. Ему будет возвращен статус <Новый>");
            ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.МенеджерПотоковФормированияСообщений", УровеньЖурналаРегистрации.Информация,,,ТекстСообщенияЖР);
            
            РегистрыСведений.инт_ТекущийСтатусРассылкиСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Сообщение.Подписчик, Перечисления.инт_СтатусыРассылкиИсходящихСообщений.Новый);
        КонецЕсли;
    КонецЦикла;
КонецПроцедуры

// Процедура - Удалить поток из менеджера
//
// Параметры:
//  ИдентификаторПотока  -   УникальныйИдентификтор   - УИД Фонового задания потока. Удаляется или при успешном завершении, или при сборке мусора.
//
Процедура УдалитьПотокИзМенеджера(ИдентификаторПотока)
   Запись = РегистрыСведений.инт_МенеджерПотоковОтправкиСообщений.СоздатьМенеджерЗаписи();
   Запись.ИдентификаторПотока = ИдентификаторПотока;
   Запись.Удалить();
КонецПроцедуры

#КонецОбласти

#КонецЕсли
