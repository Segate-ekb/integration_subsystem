﻿////////////////////////////////////////////////////////////////////////////////

// инт_ФормированиеИсходящихСообщений

//  

////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс
Процедура ЗапускМенеджераПотоков() Экспорт
    РегистрыСведений.инт_МенеджерПотоковФормированияСообщений.СобратьМусор();
    
    КоличествоПотоковКСозданию = РегистрыСведений.инт_МенеджерПотоковФормированияСообщений.КоличествоПотоковКСозданию();
    Для Итератор=1 По КоличествоПотоковКСозданию Цикл
        СоздатьПотокФормированияСообщений();
    КонецЦикла;
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура СоздатьПотокФормированияСообщений()
    КоличествоСообщенийВПачке = инт_ФормированиеИсходящихСообщенийПовтИсп.РазмерПачкиФормированияСообщений();
    МассивСообщений = РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ПолучитьИдентификаторыСообщенийКФормированию(КоличествоСообщенийВПачке);
    
    Если МассивСообщений.Количество() = 0 Тогда
        // Нет сообщений для обработки.
    	Возврат;
    КонецЕсли;
    НачатьТранзакцию();
    Попытка
        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщений(МассивСообщений, Перечисления.инт_СтатусыИсходящихСообщений.ФормированиеСообщения);
        МассивПараметров = Новый Массив;
        МассивПараметров.Добавить(МассивСообщений);
        Поток = ФоновыеЗадания.Выполнить("инт_ФормированиеИсходящихСообщенийСлужебный.ВыполнитьОбработкуСообщенийВПотоке", МассивПараметров, ,"Поток формирования исходящих сообщений.");
        РегистрыСведений.инт_МенеджерПотоковФормированияСообщений.ЗарегистрироватьПоток(Поток.УникальныйИдентификатор, МассивСообщений);
        ЗафиксироватьТранзакцию();
    Исключение
        ОтменитьТранзакцию();
        СообщениеОбОшибке = СтрШаблон("Ошибка при создании потока формирования сообщений.
        |
        |Информация об ошибке: %1", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.МенеджерПотоковФормированияСообщений", УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
    КонецПопытки;
    
КонецПроцедуры
#КонецОбласти
