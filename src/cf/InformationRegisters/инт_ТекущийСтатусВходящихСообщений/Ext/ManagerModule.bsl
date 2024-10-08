﻿////////////////////////////////////////////////////////////////////////////////

// <инт_ТекущийСтатусВходящихСообщений>

//  

////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
// Процедура - Записать статус сообщения
// Записывает в регистр текущий статус сообщения. 
// Если Статус "ОшибкаФормирования" или "ОшибкаОтправки" тогда обязательно указание текста ошибки.
// В случае фиксации статуса ошибки - выполняется расчет попыток отправки.
//
// Параметры:
//  ИдентификаторСообщения     -  УникальныйИдентификатор  - Уникальный идентификатор сообщения
//  Статус                     -  ПеречислениеСсылка.инт_СтатусыВходящихСообщений  -  Статус сообщения.
//  ТекстОшибки                -  Строка    - Текст ошибки при формировании сообщения
//
Процедура ЗаписатьСтатусСообщения(ИдентификаторСообщения, СтатусСообщения, ТекстОшибки="") Экспорт
    Если Перечисления.инт_СтатусыВходящихСообщений.ЭтоОшибочныйСтатус(СтатусСообщения) Тогда
        // Если ошибка, надо будет посчитать количество попыток и тд.
        ЗафиксироватьОшибку(ИдентификаторСообщения, СтатусСообщения, ТекстОшибки);
    Иначе
        ЗафиксироватьСтатус(ИдентификаторСообщения, СтатусСообщения);
    КонецЕсли;
КонецПроцедуры

// Процедура - Записать статус сообщений
//
// Параметры:
//  МассивИдентификаторовСообщений      -  Массив   - Массив уникальных идентификаторов сообщений, для которых будет осуществлена запись статуса
//  СтатусСообщений                     -  ПеречислениеСсылка.инт_СтатусыВходящихСообщений  -  Статус сообщения. 
//  ТекстОшибки                         -  Строка    - Текст ошибки при формировании сообщения
Процедура ЗаписатьСтатусСообщений(МассивИдентификаторовСообщений, СтатусСообщений, ТекстОшибки="") Экспорт
    Для Каждого ИдентификаторСообщения Из МассивИдентификаторовСообщений Цикл
    	ЗаписатьСтатусСообщения(ИдентификаторСообщения, СтатусСообщений, ТекстОшибки);
    КонецЦикла;
КонецПроцедуры

// Функция - Получить идентификаторы сообщений по статусу
//
// Параметры:
//  СтатусСообщения -   ПеречеслениеСсылка.инт_СтатусыВходящихСообщений  - Текущий статус сообщения для отбора
//  Количество      -   Число - Ограничение по количеству, если хочется получить порцию. По умолчанию 0, это значит, что будут получены все сообщения без ограничений.
// 
// Возвращаемое значение:
//  Массив - Массив идентификаторов сообщений в требуемом статусе.
//
Функция ПолучитьИдентификаторыСообщенийПоСтатусу(СтатусСообщения, Количество = 0) Экспорт
    МассивИдентификаторов = Новый массив;
    
    ПодстрокаОграничения = ?(Количество > 0, "ПЕРВЫЕ "+Строка(Количество), "");
    Запрос = Новый Запрос;
    Запрос.Текст = СтрШаблон("ВЫБРАТЬ %1
                   |    инт_ТекущийСтатусВходящихСообщений.ИдентификаторСообщения КАК ИдентификаторСообщения
                   |ИЗ
                   |    РегистрСведений.инт_ТекущийСтатусВходящихСообщений КАК инт_ТекущийСтатусВходящихСообщений
                   |ГДЕ
                   |    инт_ТекущийСтатусВходящихСообщений.СтатусСообщения = &СтатусСообщения", ПодстрокаОграничения);
    Запрос.УстановитьПараметр("СтатусСообщения", СтатусСообщения);
    ТаблицаВыборка = Запрос.Выполнить().Выгрузить();
    МассивИдентификаторов = ТаблицаВыборка.ВыгрузитьКолонку("ИдентификаторСообщения");
    
    Возврат МассивИдентификаторов;
КонецФункции

// Функция - Текущий статус сообщения по идентификатору
//
// Параметры:
//  ИдентификаторСообщения     -   УникальныйИдентификатор, Строка   - ИдентификаторСообщения
// 
// Возвращаемое значение:
//   ПеречислениеСсылка.инт_СтатусыВходящихСообщений - Текущий статус сообщения. Если сообщение не найдено, вернется "Неопределено"
//
Функция ТекущийСтатусСообщенияПоИдентификатору(Знач ИдентификаторСообщения) Экспорт
    Статус = Неопределено;
    Если ТипЗнч(ИдентификаторСообщения) = Тип("Строка") Тогда
    	ИдентификаторСообщения = Новый УникальныйИдентификатор(ИдентификаторСообщения);
    КонецЕсли;
    
    Запрос = Новый запрос;
    Запрос.Текст = "ВЫБРАТЬ
                   |    инт_ТекущийСтатусВходящихСообщений.СтатусСообщения КАК СтатусСообщения
                   |ИЗ
                   |    РегистрСведений.инт_ТекущийСтатусВходящихСообщений КАК инт_ТекущийСтатусВходящихСообщений
                   |ГДЕ
                   |    инт_ТекущийСтатусВходящихСообщений.ИдентификаторСообщения = &ИдентификаторСообщения";
    Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторСообщения);
    Выборка = Запрос.Выполнить().Выбрать();
    
    Если Выборка.Следующий() Тогда
    	Статус = Выборка.СтатусСообщения;
    КонецЕсли;
    
    Возврат Статус;
КонецФункции

// Функция - Получить идентификаторы сообщений к формированию
// Выбирает идентификаторы сообщений в статусе "новый" и в статусе "Ошибка при формировании", если количество попыток < возможных в потоке
// Параметры:
//  Количество      -   Число - Ограничение по количеству, если хочется получить порцию. По умолчанию 0, это значит, что будут получены все сообщения без ограничений.
// 
// Возвращаемое значение:
//  Массив - Массив идентификаторов сообщений к формированию.
//
Функция ПолучитьИдентификаторыСообщенийКФормированию(Количество = 0) Экспорт
    МассивИдентификаторов = Новый массив;
    
    ПодстрокаОграничения = ?(Количество > 0, "ПЕРВЫЕ "+Формат(Количество, "ЧГ="), "");
    Запрос = Новый запрос;
    Запрос.Текст = СтрШаблон("ВЫБРАТЬ %1
                   |    инт_ТекущийСтатусВходящихСообщений.ИдентификаторСообщения КАК ИдентификаторСообщения
                   |ПОМЕСТИТЬ ВыборкаТребуемых
                   |ИЗ
                   |    РегистрСведений.инт_ТекущийСтатусВходящихСообщений КАК инт_ТекущийСтатусВходящихСообщений
                   |ГДЕ
                   |    инт_ТекущийСтатусВходящихСообщений.СтатусСообщения = ЗНАЧЕНИЕ(Перечисление.инт_СтатусыВходящихСообщений.новый)
                   |
                   |ОБЪЕДИНИТЬ
                   |
                   |ВЫБРАТЬ %1
                   |    инт_ТекущийСтатусВходящихСообщений.ИдентификаторСообщения
                   |ИЗ
                   |    РегистрСведений.инт_ТекущийСтатусВходящихСообщений КАК инт_ТекущийСтатусВходящихСообщений
                   |        ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.инт_ОчередьВходящихСообщений КАК инт_ОчередьВходящихСообщений
                   |            ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.инт_ПотокиДанных КАК инт_ПотокиДанных
                   |            ПО инт_ОчередьВходящихСообщений.ПотокДанных = инт_ПотокиДанных.Ссылка
                   |        ПО инт_ТекущийСтатусВходящихСообщений.ИдентификаторСообщения = инт_ОчередьВходящихСообщений.ИдентификаторСообщения
                   |            И инт_ТекущийСтатусВходящихСообщений.СтатусСообщения = ЗНАЧЕНИЕ(Перечисление.инт_СтатусыВходящихСообщений.ОшибкаОбработки)
                   |ГДЕ
                   |
                   |    инт_ПотокиДанных.КоличествоПопытокОбработки > инт_ТекущийСтатусВходящихСообщений.КоличествоПопыток
                   |;
                   |
                   |////////////////////////////////////////////////////////////////////////////////
                   |ВЫБРАТЬ %1
                   |    ВыборкаТребуемых.ИдентификаторСообщения КАК ИдентификаторСообщения
                   |ИЗ
                   |    ВыборкаТребуемых КАК ВыборкаТребуемых", ПодстрокаОграничения);
 
    ТаблицаВыборка = Запрос.Выполнить().Выгрузить();
    
    МассивИдентификаторов = ТаблицаВыборка.ВыгрузитьКолонку("ИдентификаторСообщения");
    
    Возврат МассивИдентификаторов;
КонецФункции

// Процедура - Удалить запись по идентификатору
//
// Параметры:
//  ИдентификаторСообщения  - УникальныйИдентификатор - ИдентификаторСообщения
//
Процедура УдалитьЗаписьПоИдентификатору(ИдентификаторСообщения) Экспорт

	Запись = РегистрыСведений.инт_ТекущийСтатусВходящихСообщений.СоздатьМенеджерЗаписи();
	Запись.ИдентификаторСообщения = ИдентификаторСообщения;
	Запись.Удалить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура ЗафиксироватьОшибку(ИдентификаторСообщения, СтатусСообщения, ТекстОшибки)
    НомерПопытки = ПолучитьНомерПопыткиПоИдентификатору(ИдентификаторСообщения);
    ДатаСледующейПопытки = РасчитатьДатуСледующейПопытки(ИдентификаторСообщения);
    
    ЗафиксироватьСтатус(ИдентификаторСообщения, СтатусСообщения, ТекстОшибки, НомерПопытки, ДатаСледующейПопытки);
КонецПроцедуры
 
Функция ПолучитьНомерПопыткиПоИдентификатору(ИдентификаторСообщения)
    КоличествоПопыток = 1;
    Запрос = Новый запрос;
    Запрос.Текст = "ВЫБРАТЬ
                   |    инт_ТекущийСтатусВходящихСообщений.КоличествоПопыток КАК КоличествоПопыток
                   |ИЗ
                   |    РегистрСведений.инт_ТекущийСтатусВходящихСообщений КАК инт_ТекущийСтатусВходящихСообщений
                   |ГДЕ
                   |    инт_ТекущийСтатусВходящихСообщений.ИдентификаторСообщения = &ИдентификаторСообщения";
    Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторСообщения);
    Выборка = Запрос.Выполнить().Выбрать();
    Если Выборка.Следующий() Тогда
       КоличествоПопыток = Выборка.КоличествоПопыток+1;
    КонецЕсли;
    
	Возврат КоличествоПопыток;
КонецФункции

Процедура ЗафиксироватьСтатус(ИдентификаторСообщения, СтатусСообщения, ТекстОшибки="", НомерПопытки=0, ДатаСледующейПопытки = Неопределено)
	Запись = РегистрыСведений.инт_ТекущийСтатусВходящихСообщений.СоздатьМенеджерЗаписи();
    Запись.ИдентификаторСообщения = ИдентификаторСообщения;
    Запись.СтатусСообщения = СтатусСообщения;
    Запись.КоличествоПопыток = НомерПопытки;
    Запись.ТекстОшибки = ТекстОшибки;
    Если НЕ ДатаСледующейПопытки = Неопределено Тогда
        Запись.ДатаСледующейПопытки = ДатаСледующейПопытки;
    КонецЕсли;
    Запись.Записать(Истина);
КонецПроцедуры

Функция РасчитатьДатуСледующейПопытки(ИдентификаторСообщения)
	ИнформацияОСообщении = РегистрыСведений.инт_ОчередьВходящихСообщений.ПолучитьДанныеОчередиПоИдентификатору(ИдентификаторСообщения, "ПотокДанных");
    Возврат Справочники.инт_ПотокиДанных.РасчитатьДатуСледующейПопыткиПоДате(ТекущаяДата(),ИнформацияОСообщении.ПотокДанных);
    
КонецФункции

#КонецОбласти

#КонецЕсли
