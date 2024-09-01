﻿#Область ПрограммныйИнтерфейс
// Процедура - Записать статус сообщения
// Записывает в регистр текущий статус сообщения. 
// Если Статус "ОшибкаОбработки" тогда обязательно указание текста ошибки.
// В случае фиксации статуса ошибки - выполняется расчет попыток отправки.
//
// Параметры:
//  ИдентификаторСообщения     -  УникальныйИдентификатор  - Уникальный идентификатор сообщения
//  Статус                     -  ПеречислениеСсылка.инт_СтатусыИсходящихСообщений  -  Статус сообщения.
//  ТекстОшибки                -  Строка    - Текст ошибки при формировании сообщения
//
Процедура ЗаписатьСтатусСообщения(ИдентификаторСообщения, Подписчик, СтатусСообщения, ТекстОшибки="") Экспорт
    Если Перечисления.инт_СтатусыРассылкиИсходящихСообщений.ЭтоОшибочныйСтатус(СтатусСообщения) Тогда
        // Если ошибка, надо будет посчитать количество попыток и тд.
        ЗафиксироватьОшибку(ИдентификаторСообщения, Подписчик, СтатусСообщения, ТекстОшибки);
    Иначе
        ЗафиксироватьСтатус(ИдентификаторСообщения, Подписчик, СтатусСообщения);
    КонецЕсли;
КонецПроцедуры

// Процедура - Записать статус сообщений
//
// Параметры:
//  МассивСообщений                     -  Массив   - Массив структур <УникальныйИдентификатор, Подписчик> сообщений, для которых будет осуществлена запись статуса
//  СтатусСообщений                     -  ПеречислениеСсылка.инт_СтатусыРассылкиИсходящихСообщений  -  Статус сообщения. 
//  ТекстОшибки                         -  Строка    - Текст ошибки при формировании сообщения
Процедура ЗаписатьСтатусСообщений(МассивСообщений, СтатусСообщений, ТекстОшибки="") Экспорт
    Для Каждого Сообщение Из МассивСообщений Цикл
    	ЗаписатьСтатусСообщения(Сообщение.ИдентификаторСообщения, Сообщение.Подписчик, СтатусСообщений, ТекстОшибки);
    КонецЦикла;
КонецПроцедуры

// Функция - Текущий статус сообщения по идентификатору
//
// Параметры:
//  ИдентификаторСообщения     -   УникальныйИдентификатор, Строка   - ИдентификаторСообщения
//  Подписчик - СправочникСсылка.инт_Подписчики - Ссылка на подписчика  
//
// Возвращаемое значение:
//   ПеречислениеСсылка.инт_СтатусыИсходящихСообщений - Текущий статус сообщения. Если сообщение не найдено, вернется "Неопределено"
//
Функция ТекущийСтатусСообщения(Знач ИдентификаторСообщения, Подписчик) Экспорт
    Статус = Неопределено;
    Если ТипЗнч(ИдентификаторСообщения) = Тип("Строка") Тогда
    	ИдентификаторСообщения = Новый УникальныйИдентификатор(ИдентификаторСообщения);
    КонецЕсли;
    
    Запрос = Новый запрос;
    Запрос.Текст = "ВЫБРАТЬ
                   |    инт_ТекущийСтатусРассылкиСообщений.СтатусСообщения КАК СтатусСообщения
                   |ИЗ
                   |    РегистрСведений.инт_ТекущийСтатусРассылкиСообщений КАК инт_ТекущийСтатусРассылкиСообщений
                   |ГДЕ
                   |    инт_ТекущийСтатусРассылкиСообщений.ИдентификаторСообщения = &ИдентификаторСообщения
                   |       И инт_ТекущийСтатусРассылкиСообщений.Подписчик = &Подписчик";
    Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторСообщения);
    Запрос.УстановитьПараметр("Подписчик", Подписчик);
    Выборка = Запрос.Выполнить().Выбрать();
    
    Если Выборка.Следующий() Тогда
    	Статус = Выборка.СтатусСообщения;
    КонецЕсли;
    
    Возврат Статус;
КонецФункции

// Функция - Получить сообщения к Отправке
// Получает сообщения к отправке. Или те что в статусе <новое> или в статусе <ОшибкаОбработки и с количеством попыток менее максимального
// Параметры:
//  КоличествоСообщенийВПачке     - число - Если 0, то получает все возможные сообщения
//  ТипПодписчика                 - ПеречислениеСсылка.инт_ТипыПодписчиков - Ограничивает выборку сообщениями только подписчикам у которых указанный типПодписчика
// 
// Возвращаемое значение:
//  массив - Массив структур <ИдентификаторСообщения, Подписчик>
//
Функция ПолучитьСообщенияКОтправке(КоличествоСообщенийВПачке, ТипПодписчика) Экспорт
    МассивСообщений = Новый массив;
    
    ПодстрокаОграничения = ?(КоличествоСообщенийВПачке > 0, "ПЕРВЫЕ "+Формат(КоличествоСообщенийВПачке,"ЧГ="), "");

    Запрос = Новый Запрос;
    Запрос.Текст = СтрШаблон("ВЫБРАТЬ %1
                   |    инт_ТекущийСтатусРассылкиСообщений.ИдентификаторСообщения КАК ИдентификаторСообщения,
                   |    инт_ТекущийСтатусРассылкиСообщений.Подписчик КАК Подписчик
                   |ПОМЕСТИТЬ ПромежуточныйИтог
                   |ИЗ
                   |    Справочник.инт_Подписчики КАК инт_Подписчики
                   |        ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.инт_ТекущийСтатусРассылкиСообщений КАК инт_ТекущийСтатусРассылкиСообщений
                   |        ПО инт_Подписчики.Ссылка = инт_ТекущийСтатусРассылкиСообщений.Подписчик
                   |            И (инт_Подписчики.ТипПодписчика = &ТипПодписчика)
                   |            И (инт_ТекущийСтатусРассылкиСообщений.СтатусСообщения = ЗНАЧЕНИЕ(Перечисление.инт_СтатусыРассылкиИсходящихСообщений.Новый))
                   |
                   |ОБЪЕДИНИТЬ ВСЕ
                   |
                   |ВЫБРАТЬ %1
                   |    инт_ТекущийСтатусРассылкиСообщений.ИдентификаторСообщения,
                   |    инт_ТекущийСтатусРассылкиСообщений.Подписчик
                   |ИЗ
                   |    РегистрСведений.инт_ТекущийСтатусРассылкиСообщений КАК инт_ТекущийСтатусРассылкиСообщений
                   |        ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.инт_Подписчики КАК инт_Подписчики
                   |        ПО инт_ТекущийСтатусРассылкиСообщений.Подписчик = инт_Подписчики.Ссылка
                   |            И (инт_Подписчики.ТипПодписчика = &ТипПодписчика)
                   |            И инт_ТекущийСтатусРассылкиСообщений.ДатаСледующейПопытки <= &ТекущаяДата
                   |            И инт_ТекущийСтатусРассылкиСообщений.КоличествоПопыток < инт_Подписчики.КоличествоПопытокОтправки
                   |            И (инт_ТекущийСтатусРассылкиСообщений.СтатусСообщения = ЗНАЧЕНИЕ(Перечисление.инт_СтатусыРассылкиИсходящихСообщений.ОшибкаОбработки))
                   |;
                   |
                   |////////////////////////////////////////////////////////////////////////////////
                   |ВЫБРАТЬ %1
                   |    ПромежуточныйИтог.ИдентификаторСообщения КАК ИдентификаторСообщения,
                   |    ПромежуточныйИтог.Подписчик КАК Подписчик
                   |ИЗ
                   |    ПромежуточныйИтог КАК ПромежуточныйИтог", ПодстрокаОграничения);
    Запрос.УстановитьПараметр("ТипПодписчика", ТипПодписчика);
    Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
    
    Выборка = Запрос.Выполнить().Выбрать();
    Пока Выборка.Следующий() Цикл
    	СтруктураСообщения = Новый Структура("ИдентификаторСообщения,Подписчик", Выборка.ИдентификаторСообщения, Выборка.Подписчик);
        МассивСообщений.Добавить(СтруктураСообщения);
    КонецЦикла;
    Возврат МассивСообщений;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура ЗафиксироватьОшибку(ИдентификаторСообщения, Подписчик, СтатусСообщения, ТекстОшибки)
    НомерПопытки = ПолучитьНомерПопыткиОтправкиСообщения(ИдентификаторСообщения, Подписчик);
    ДатаСледующейПопытки = Справочники.инт_Подписчики.РасчитатьДатуСледующейПопыткиПоДате(ТекущаяДата(),Подписчик);
    ЗафиксироватьСтатус(ИдентификаторСообщения, Подписчик, СтатусСообщения, ТекстОшибки, НомерПопытки, ДатаСледующейПопытки);
КонецПроцедуры
 
Функция ПолучитьНомерПопыткиОтправкиСообщения(ИдентификаторСообщения, Подписчик)
    КоличествоПопыток = 1;
    // в текущей парадигме, считается, что статус ошибки не может "перескакивать" с одной ошибки на другую.
    Запрос = Новый запрос;
    Запрос.Текст = "ВЫБРАТЬ
                   |    инт_ТекущийСтатусРассылкиСообщений.КоличествоПопыток КАК КоличествоПопыток
                   |ИЗ
                   |    РегистрСведений.инт_ТекущийСтатусРассылкиСообщений КАК инт_ТекущийСтатусРассылкиСообщений
                   |ГДЕ
                   |    инт_ТекущийСтатусРассылкиСообщений.ИдентификаторСообщения = &ИдентификаторСообщения
                   |    И инт_ТекущийСтатусРассылкиСообщений.Подписчик = &Подписчик";
    Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторСообщения);
        Запрос.УстановитьПараметр("Подписчик", Подписчик);
    Выборка = Запрос.Выполнить().Выбрать();
    Если Выборка.Следующий() Тогда
       КоличествоПопыток = Выборка.КоличествоПопыток+1;
    КонецЕсли;
    
	Возврат КоличествоПопыток;
КонецФункции

Процедура ЗафиксироватьСтатус(ИдентификаторСообщения, Подписчик, СтатусСообщения, ТекстОшибки="", НомерПопытки=0, ДатаСледующейПопытки = Неопределено)
	Запись = РегистрыСведений.инт_ТекущийСтатусРассылкиСообщений.СоздатьМенеджерЗаписи();
    Запись.ИдентификаторСообщения = ИдентификаторСообщения;
    Запись.СтатусСообщения = СтатусСообщения;
    Запись.КоличествоПопыток = НомерПопытки;
    Запись.Подписчик = Подписчик;
    Запись.ТекстОшибки = ТекстОшибки;
    Если НЕ ДатаСледующейПопытки = Неопределено Тогда
    Запись.ДатаСледующейПопытки = ДатаСледующейПопытки;
    КонецЕсли;
    Запись.Записать(Истина);
КонецПроцедуры

#КонецОбласти
