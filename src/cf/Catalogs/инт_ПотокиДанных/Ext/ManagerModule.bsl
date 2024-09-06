﻿////////////////////////////////////////////////////////////////////////////////

// инт_ПотокиДанных

//  

////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция - Сформировать сообщение по потоку
//
// Параметры:
//  ИсходныеДанные     -    ОпределяемыйТип.инт_ИсходныеДанные   -   Ссылка на объект от которого будет сформировано сообщение
//  ПотокДанных        -    СправочникСсылка.инт_ПотокиДанных    - 
// 
// Возвращаемое значение:
//  Соответствие - Подготовленное для сериализации соответствие.
//
Функция СформироватьСообщениеПоПотоку(ИсходныеДанные, ПотокДанных) Экспорт
    
    Если ПотокДанных.НаправлениеПотока = Перечисления.инт_НаправлениеПотокаДанных.Входящий Тогда
    	ВызватьИсключение("Нельзя формировать сообщения по входящим потокам данных!");
    КонецЕсли;
    
    СформированноеСообщение = Новый Соответствие;
    
    Код = ПотокДанных.ТекстОбработчика;
    // Начало замера времени выполнения --------------------------------------------------------------------------------- {
    // TODO: Добавить сохранение времени формирования для отправки в монторинг
    //НачалоЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
    
    Попытка
        СформированноеСообщение = Исполнить(ПотокДанных.ТекстОбработчика, ИсходныеДанные);
    Исключение
        СообщениеОбОшибке = СтрШаблон("При формировании сообщения по потоку <%1> из исходных данных <%2> возникла ошибка!
        |
        | Информация об ошибке: %3",
        ПотокДанных,
        ИсходныеДанные,
        ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
        
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.ПотокиДанных.ФормированиеИсходящегоСообщения",
                                    УровеньЖурналаРегистрации.Ошибка,
                                    Метаданные.НайтиПоТипу(Тип(ИсходныеДанные)),
                                    ИсходныеДанные,
                                    СообщениеОбОшибке);
    КонецПопытки;

    // Конец замера { ---------------------------------------------------------------------------------------------------
    //ВремяВыполнения = ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЗамера;
    
    Если ПотокДанных.Валидация Тогда
        // TODO: Имплементировать валидацию пакета.	
    КонецЕсли;
    
  	Возврат СформированноеСообщение;
КонецФункции

Функция ПолучитьПодписчиковПоПотоку(ПотокДанных) Экспорт

    Запрос = Новый запрос;
    Запрос.Текст = "ВЫБРАТЬ
                   |    инт_ПотокиДанныхПодписчикиПотока.Подписчик КАК Подписчик
                   |ИЗ
                   |    Справочник.инт_ПотокиДанных.ПодписчикиПотока КАК инт_ПотокиДанныхПодписчикиПотока
                   |ГДЕ
                   |    инт_ПотокиДанныхПодписчикиПотока.Ссылка = &ПотокДанных";
    Запрос.УстановитьПараметр("ПотокДанных",ПотокДанных);
    ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
    Возврат ТаблицаРезультат.ВыгрузитьКолонку("Подписчик");
    
КонецФункции

// Процедура - Обработать входящее сообщение по потоку
// Принимает на вход Соответствие десериализованного сообщения, и обрабатывает его обработчиком из потока.
// Параметры:
//  СоответствиеСообщения     - Соответствие - Соответствие содержащее данные сообщения
//  ПотокДанных                 -  СправочникСсылка.инт_ПотокиДанных    - Поток данных сообщения
//
Процедура ОбработатьВходящееСообщениеПоПотоку(СоответствиеСообщения, ПотокДанных) Экспорт
	 Код = ПотокДанных.ТекстОбработчика;
     Выполнить(Код);
     
КонецПроцедуры


// Функция - Расчитать дату следующей попытки по дате
//
// Параметры:
//  ДатаНачальная         -   Дата   - Дата от которой будет Отсчитываться пауза
//  ПотокДанных     - СправочникСсылка.инт_Подписчики - подписчик для которого будет делаться расчет
// Возвращаемое значение:
//  Дата - Дата следующей попытки.
Функция РасчитатьДатуСледующейПопыткиПоДате(ДатаНачальная, ПотокДанных) Экспорт
   Возврат Дата(ДатаНачальная+ПотокДанных.ПаузаМеждуПопыткамиОбработки);
КонецФункции

// Функция - Валидировать сообщение по потоку
//
// Параметры:
//  Сообщение     - Соответствие, Структура, строка, число, Булево - валидируемое сообщение 
//  ПотокДанных     -   СправочникСсылка.инт_ПотокиДанных   - Поток по которому происходит валидация.
// 
// Возвращаемое значение:
//  Структура - <ВалидацияУспешна, СтрокаОшибки>  Структура результата валидации
//
Функция ВалидироватьСообщениеПоПотоку(Сообщение, ПотокДанных) Экспорт
		Возврат Истина;
КонецФункции

// Функция - Получить поток по идентификатору
//
// Параметры:
//  ИдентификаторПотока     -  Строка    -  Идентификатор потока. В базе используется КОД!
//  НаправлениеПотока     -  ПеречислениеСсылка.инт_НаправлениеПотокаДанных - Направление потока. Если не задано - будет найден любой поток с подобным идентификатором.
// 
// Возвращаемое значение:
//  СправочникСсылка.инт_ПотокиДанных - Если не существует ни одного элемента с требуемым кодом, то будет возвращена пустая ссылка.
//
Функция ПолучитьПотокПоИдентификатору(ИдентификаторПотока, НаправлениеПотока = Неопределено) Экспорт
ПотокДанных = Справочники.инт_ПотокиДанных.ПустаяСсылка();

Запрос = Новый Запрос;

СтрокаУсловияПоНаправлениюПотока = "";
Если ЗначениеЗаполнено(НаправлениеПотока) Тогда
	Запрос.УстановитьПараметр("НаправлениеПотока", НаправлениеПотока);
    СтрокаУсловияПоНаправлениюПотока = "И инт_ПотокиДанных.НаправлениеПотока = &НаправлениеПотока";
КонецЕсли;

Запрос.Текст = СтрШаблон("ВЫБРАТЬ ПЕРВЫЕ 1
               |    инт_ПотокиДанных.Ссылка КАК Ссылка
               |ИЗ
               |    Справочник.инт_ПотокиДанных КАК инт_ПотокиДанных
               |ГДЕ
               |    инт_ПотокиДанных.Код = &ИдентификаторПотока
               |%1",СтрокаУсловияПоНаправлениюПотока);
Запрос.УстановитьПараметр("ИдентификаторПотока", ИдентификаторПотока);

Выборка = Запрос.Выполнить().Выбрать();
Если Выборка.Следующий() Тогда
	ПотокДанных = Выборка.Ссылка;
КонецЕсли;

Возврат ПотокДанных;    
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

 Функция Исполнить(Код, ИсходныеДанные)

	Результат = Новый Соответствие;

		УстановитьБезопасныйРежим(Истина);
		// BSLLS:ExecuteExternalCodeInCommonModule-off
		Выполнить(Код);
		// BSLLS:ExecuteExternalCodeInCommonModule-on
	    УстановитьБезопасныйРежим(Ложь);

	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
