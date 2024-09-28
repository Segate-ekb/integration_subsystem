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
    
    Если Не ПотокДанных.НаправлениеПотока = Перечисления.инт_НаправлениеПотокаДанных.Исходящий Тогда
    	ВызватьИсключение("Нельзя формировать сообщения по входящим потокам данных!");
    КонецЕсли;
    
    СформированноеСообщение = Новый Соответствие;
        
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
                                    Метаданные.НайтиПоТипу(ТипЗнч(ИсходныеДанные)),
                                    ИсходныеДанные,
                                    СообщениеОбОшибке);
        ВызватьИсключение;
    КонецПопытки;
    
    Если ПотокДанных.Валидация Тогда
        ВалидироватьСообщениеПоПотоку(СформированноеСообщение, ПотокДанных);
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
Процедура ОбработатьВходящееСообщениеПоПотоку(СоответствиеСообщения, ПотокДанных, РазрешитьФиксациюИзменений = Истина) Экспорт
    
    Если Не ПотокДанных.НаправлениеПотока = Перечисления.инт_НаправлениеПотокаДанных.Входящий Тогда
    	ВызватьИсключение("Нельзя обрабатывать сообщение не по входящим потокам!");
    КонецЕсли;
    
    // Начало замера времени выполнения --------------------------------------------------------------------------------- {
    // TODO: Добавить сохранение времени формирования для отправки в монторинг
    //НачалоЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
    
    Попытка
        Исполнить(ПотокДанных.ТекстОбработчика, СоответствиеСообщения, РазрешитьФиксациюИзменений);
    Исключение
        СообщениеОбОшибке = СтрШаблон("При обработке сообщения по потоку <%1> возникла ошибка!
        |
        | Информация об ошибке: %2",
        ПотокДанных,
        ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
        
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.ПотокиДанных.ОбработкаВходящегоСообщения",
                                    УровеньЖурналаРегистрации.Ошибка,
                                    ,
                                    ,
                                    СообщениеОбОшибке);
        ВызватьИсключение;
    КонецПопытки;

    // Конец замера { ---------------------------------------------------------------------------------------------------
    //ВремяВыполнения = ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЗамера;
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

// Процедура - Валидировать сообщение по потоку
//
// Параметры:
//  Сообщение     - Соответствие, Структура, строка, число, Булево - валидируемое сообщение 
//  ПотокДанных     -   СправочникСсылка.инт_ПотокиДанных   - Поток по которому происходит валидация.
// 
Процедура ВалидироватьСообщениеПоПотоку(Сообщение, ПотокДанных) Экспорт
	Если Не ПотокДанных.Валидация Тогда
		// Валидация не требуется, потому просто вернем инстину.
		Возврат;
	КонецЕсли;
		МассивОшибок = инт_ВалидаторПакетов.Валидировать(Сообщение, ПотокДанных.ИмяСхемыПакета, ПотокДанных.СхемаДанных);
        Если Не МассивОшибок.Количество() = 0 Тогда
            БлокОшибок = "";
            Для Каждого Ошибка Из МассивОшибок Цикл
            	БлокОшибок = БлокОшибок+Ошибка+Символы.ПС;
            КонецЦикла;
            
            СообщениеОбОшибке = СтрШаблон("При обработке сообщения по потоку <%1> возникла ошибка валидации!
            |
            | Информация об ошибке:
            |%2",ПотокДанных.Наименование, БлокОшибок);
            ВызватьИсключение СообщениеОбОшибке;
        КонецЕсли;
КонецПроцедуры

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

// Функция - Заполнить дерево реквизитов по ссылке
//	Создает дерево реквизитов с признаком отслеживания по ссылке на объект
// Параметры:
//  СсылкаНаОбъект	 -  ОпределяемыйТип.инт_ИсходныеДанные - Ссылка на объект по которому строится дерево реквизитов.
//  ИсходныеДанные	 - 	ДеревоЗначений - Дерево которое будет взято за основу при построении. 
// 
// Возвращаемое значение:
//  ДеревоЗначений - ДеревоЗначений реквизитов с признаком отслеживания при регистрации изменений.
//
Функция ЗаполнитьДеревоРеквизитовПоСсылке(СсылкаНаОбъект, ИсходныеДанные = Неопределено) Экспорт

	Дерево = ИнициализироватьДерево();
	
	Если ИсходныеДанные=Неопределено Тогда
		ИсходныеДанные = Дерево.Скопировать();
	КонецЕсли;

	МетаданныеОбъекта = СсылкаНаОбъект.Метаданные();
	СтрокаИсходныхДанных = ИсходныеДанные.Строки.Найти(МетаданныеОбъекта.Имя,"Имя", Ложь);
	СтрокаОбъект = Дерево.Строки.Добавить();
	Если СтрокаИсходныхДанных = Неопределено Тогда
		СтрокаОбъект.Картинка = ПодобратьКартинкуПоТипу(СсылкаНаОбъект);
		СтрокаОбъект.Синоним = МетаданныеОбъекта.Синоним;
		СтрокаОбъект.Имя = МетаданныеОбъекта.Имя;
		СтрокаОбъект.ОтслеживатьИзменения = Истина;
		ДочерниеОбъектыИсходныхДанных = Неопределено;
	Иначе
		ЗаполнитьЗначенияСвойств(СтрокаОбъект, СтрокаИсходныхДанных);
		ДочерниеОбъектыИсходныхДанных = СтрокаИсходныхДанных.Строки;
	КонецЕсли;
	
	ЗаполнитьСтандартныеРеквизиты(СтрокаОбъект.Строки, МетаданныеОбъекта, ДочерниеОбъектыИсходныхДанных);
	ЗаполнитьРеквизиты(СтрокаОбъект.Строки, МетаданныеОбъекта, ДочерниеОбъектыИсходныхДанных);
	ЗаполнитьТабличныеЧасти(СтрокаОбъект.Строки, МетаданныеОбъекта, ДочерниеОбъектыИсходныхДанных);

	Возврат Дерево;
КонецФункции
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция Исполнить(Код, ИсходныеДанные, РазрешитьФиксациюИзменений = Ложь)
    
    Результат = Новый Соответствие;
    
    УстановитьБезопасныйРежим(Истина);
    НачатьТранзакцию();
    Попытка
        // BSLLS:ExecuteExternalCodeInCommonModule-off
        Выполнить(Код);
        // BSLLS:ExecuteExternalCodeInCommonModule-on
        Если РазрешитьФиксациюИзменений Тогда
            ЗафиксироватьТранзакцию();
        Иначе
           //Для исходящих потоков или проверок фиксация изменений не нужна. 
           ВызватьИсключение "ПлановыйОткатТранзакции";
        КонецЕсли;
        
	Исключение
        ОтменитьТранзакцию();
		Если Не ИнформацияОбОшибке().Описание = "ПлановыйОткатТранзакции" Тогда
			ВызватьИсключение;
		КонецЕсли;
    КонецПопытки;
    УстановитьБезопасныйРежим(Ложь);
    
    Возврат Результат;
    
КонецФункции

Функция ИнициализироватьДерево()
	КЧ = Новый КвалификаторыЧисла(1,0);
	КС = Новый КвалификаторыСтроки(0);
	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ОписаниеТиповС = Новый ОписаниеТипов(Массив, , КС);
	Массив.Очистить();
	Массив.Добавить(Тип("Число"));
	ОписаниеТиповЧ = Новый ОписаниеТипов(Массив, , ,КЧ);
	Массив.Очистить();
	Массив.Добавить(Тип("Картинка"));
	ОписаниеТиповКартинка = Новый ОписаниеТипов(Массив);

	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("Имя", ОписаниеТиповС);
	Дерево.Колонки.Добавить("Синоним", ОписаниеТиповС);
	Дерево.Колонки.Добавить("ОтслеживатьИзменения", ОписаниеТиповЧ);
	Дерево.Колонки.Добавить("Картинка", ОписаниеТиповКартинка);
	
	Возврат Дерево;
КонецФункции

Функция  ПодобратьКартинкуПоТипу(СсылкаНаОбъект)
	Картинка = БиблиотекаКартинок.Документ;
	Тип = ТипЗнч(СсылкаНаОбъект);
	Если Справочники.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Картинка = БиблиотекаКартинок.Справочник;
	ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Картинка = БиблиотекаКартинок.Документ;
	ИначеЕсли Перечисления.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Картинка = БиблиотекаКартинок.Перечисление;
	ИначеЕсли БизнесПроцессы.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Картинка = БиблиотекаКартинок.БизнесПроцесс;
	ИначеЕсли Задачи.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Картинка = БиблиотекаКартинок.Задача;
	Иначе
		//Не удалось определить тип объекта... Оставим документ по умолчанию.
	КонецЕсли;
	
	Возврат Картинка;
КонецФункции

Процедура ЗаполнитьРеквизиты(СтрокиОбъект, МетаданныеОбъекта, СтрокиИсходныеДанные = Неопределено)
	Если СтрокиИсходныеДанные = Неопределено Тогда
		СтрокаРеквизитыИсходныеДанные = Неопределено;
	Иначе
		СтрокаРеквизитыИсходныеДанные = СтрокиИсходныеДанные.Найти("Реквизиты", "Имя", Ложь);
	КонецЕсли;
	Попытка
		КоллекцияРеквизитов = МетаданныеОбъекта.Реквизиты;
		СтрокаРеквизиты = СтрокиОбъект.Добавить();
		Если СтрокаРеквизитыИсходныеДанные = Неопределено Тогда
			СтрокаРеквизиты.Имя = "Реквизиты";
			СтрокаРеквизиты.Синоним = "Реквизиты";
			СтрокаРеквизиты.ОтслеживатьИзменения = Истина;
		Иначе
			ЗаполнитьЗначенияСвойств(СтрокаРеквизиты, СтрокаРеквизитыИсходныеДанные);
		КонецЕсли;
		
		ЗаполнитьРеквизитыПоКоллекцииРеквизитов(КоллекцияРеквизитов, СтрокаРеквизиты, СтрокаРеквизитыИсходныеДанные);
	Исключение
		//А тут ничего не надо, если нет реквизитов, то и наплевать
	КонецПопытки;
КонецПроцедуры

Процедура ЗаполнитьСтандартныеРеквизиты(СтрокиОбъект, МетаданныеОбъекта, СтрокиИсходныеДанные = Неопределено)
	Если СтрокиИсходныеДанные = Неопределено Тогда
		СтрокаРеквизитыИсходныеДанные = Неопределено;
	Иначе
		СтрокаРеквизитыИсходныеДанные = СтрокиИсходныеДанные.Найти("СтандартныеРеквизиты", "Имя", Ложь);
	КонецЕсли;
	Попытка
		КоллекцияСтандартныхРеквизитов = МетаданныеОбъекта.СтандартныеРеквизиты;
		СтрокаРеквизиты = СтрокиОбъект.Добавить();
		Если СтрокаРеквизитыИсходныеДанные = Неопределено Тогда
			СтрокаРеквизиты.Имя = "СтандартныеРеквизиты";
			СтрокаРеквизиты.Синоним = "Стандартные реквизиты";
			СтрокаРеквизиты.ОтслеживатьИзменения = Истина;
		Иначе
			ЗаполнитьЗначенияСвойств(СтрокаРеквизиты, СтрокаРеквизитыИсходныеДанные);
		КонецЕсли;
		ЗаполнитьРеквизитыПоКоллекцииРеквизитов(КоллекцияСтандартныхРеквизитов, СтрокаРеквизиты, СтрокаРеквизитыИсходныеДанные);
	Исключение
		//А тут ничего не надо, если нет реквизитов, то и наплевать
	КонецПопытки;
КонецПроцедуры

Процедура ЗаполнитьТабличныеЧасти(СтрокиОбъект, МетаданныеОбъекта, СтрокиИсходныеДанные = Неопределено)
	Если СтрокиИсходныеДанные = Неопределено Тогда
		СтрокаТЧИсходныеДанные = Неопределено;
	Иначе
		СтрокаТЧИсходныеДанные = СтрокиИсходныеДанные.Найти("ТабличныеЧасти", "Имя", Ложь);
	КонецЕсли;

	Попытка
		КоллекцияТабЧастей = МетаданныеОбъекта.ТабличныеЧасти;
		Если КоллекцияТабЧастей.Количество() > 0 Тогда
			СтрокаТЧ = СтрокиОбъект.Добавить();
			Если СтрокаТЧИсходныеДанные = Неопределено Тогда
				СтрокаТЧ.Имя = "ТабличныеЧасти";
				СтрокаТЧ.Синоним = "Табличные части";
				СтрокаТЧ.ОтслеживатьИзменения = Истина;
			Иначе
				ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаТЧИсходныеДанные);
			КонецЕсли;
		КонецЕсли;
		Для Каждого ТабличнаяЧасть Из КоллекцияТабЧастей Цикл
			ЗаполнитьДанныеТабличнойЧасти(СтрокаТЧ, ТабличнаяЧасть, СтрокаТЧИсходныеДанные);
			
		КонецЦикла;
	Исключение
		//А тут ничего не надо, если нет ТабличныхЧастей, то и наплевать
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПоКоллекцииРеквизитов(КоллекцияРеквизитов, ИсходнаяСтрока, ИсходнаяСтрокаИсходныхДанных = Неопределено)
	Для Каждого Реквизит Из КоллекцияРеквизитов Цикл
		СтрокаРеквизит = ИсходнаяСтрока.Строки.Добавить();
		Если ИсходнаяСтрокаИсходныхДанных = Неопределено Тогда
			СтрокаРеквизитИсходныхДанных = Неопределено;
		Иначе
			СтрокаРеквизитИсходныхДанных = ИсходнаяСтрокаИсходныхДанных.Строки.Найти(Реквизит.Имя, "Имя", Ложь);
		КонецЕсли;

		Если СтрокаРеквизитИсходныхДанных = Неопределено Тогда
			СтрокаРеквизит.Картинка = БиблиотекаКартинок.Реквизит;
			СтрокаРеквизит.Имя = Реквизит.Имя;
			СтрокаРеквизит.Синоним = ?(ЗначениеЗаполнено(Реквизит.Синоним), Реквизит.Синоним, Реквизит.Имя);
			СтрокаРеквизит.ОтслеживатьИзменения = Истина;
		Иначе
			ЗаполнитьЗначенияСвойств(СтрокаРеквизит, СтрокаРеквизитИсходныхДанных);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьДанныеТабличнойЧасти(ИсходнаяСтрока, ТабличнаяЧасть,  ИсходнаяСтрокаИсходныхДанных = Неопределено)
	СтрокаТЧ = ИсходнаяСтрока.Строки.Добавить();
	Если ИсходнаяСтрокаИсходныхДанных = Неопределено Тогда
		СтрокаТЧИсходныхДанных = Неопределено;
	Иначе
		СтрокаТЧИсходныхДанных = ИсходнаяСтрокаИсходныхДанных.Строки.Найти(ТабличнаяЧасть.Имя, "Имя", Ложь);
	КонецЕсли;

	Если СтрокаТЧИсходныхДанных = Неопределено Тогда
		СтрокаТЧ.Картинка = БиблиотекаКартинок.ВложеннаяТаблица;
		СтрокаТЧ.Имя = ТабличнаяЧасть.Имя;
		СтрокаТЧ.Синоним = ТабличнаяЧасть.Синоним;
		СтрокаТЧ.ОтслеживатьИзменения = Истина;
	Иначе
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаТЧИсходныхДанных);
	КонецЕсли;
	КоллекцияРеквизитов = ТабличнаяЧасть.Реквизиты;
	ЗаполнитьРеквизитыПоКоллекцииРеквизитов(КоллекцияРеквизитов, СтрокаТЧ, СтрокаТЧИсходныхДанных);
КонецПроцедуры
#КонецОбласти

#КонецЕсли
