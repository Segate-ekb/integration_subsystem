﻿////////////////////////////////////////////////////////////////////////////////

// инт_Подписчики

//  

////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция - Сформировать сообщение по подписчику
//
// Параметры:
//  ДанныеСообщения        - Соответствие                   - Соттветствие содержащее данные для сериатизации
//  Подписчик              - СпраочникСсылка.инт_Подписчики - Ссылка на подписчика
//  ИдентификаторСообщения - УИД                            - УИД сообщения
// 
// Возвращаемое значение:
//  Строка - Сериализованное, котовое к отправке подписчику сообщение
//
Функция СформироватьСообщениеПоПодписчику(ДанныеСообщения, Подписчик, ИдентификаторСообщения) Экспорт
    // По типу подписчика определяется обработчик сообщения.
    // Может быть, если добавим jsonrpc например, будем сразу там паковать имя потока и тд...
    ОбработчикСобытий = инт_ОтправкаИсходящихСообщенийПовтИсп.
                                                ОбщийМодульОбработкиСообщенийПоТипуПодписчика(Подписчик.ТипПодписчика);
    
    Возврат ОбработчикСобытий.СформироватьСообщениеПоПодписчику(ДанныеСообщения, Подписчик, ИдентификаторСообщения);
КонецФункции

// Процедура - Отправить сообщение подписчику
//
// Параметры:
//  Сообщение     - Структура - Данные сообщения 
//
Процедура ОтправитьСообщение(Сообщение) Экспорт
    Подписчик = Сообщение.Подписчик;
    ОбработчикСобытий = инт_ОтправкаИсходящихСообщенийПовтИсп.
                                                ОбщийМодульОбработкиСообщенийПоТипуПодписчика(Подписчик.ТипПодписчика);
    ОбработчикСобытий.ОтправитьСообщение(Сообщение);

КонецПроцедуры

// Функция - Расчитать дату следующей попытки по дате
//
// Параметры:
//  ДатаНачальная         -   Дата   - Дата от которой будет Отсчитываться пауза
//  Подписчик     - СправочникСсылка.инт_Подписчики - подписчик для которого будет делаться расчет
// Возвращаемое значение:
//  Дата - дата следующей попытки отправки сообщения
Функция РасчитатьДатуСледующейПопыткиПоДате(ДатаНачальная, Подписчик) Экспорт
   Возврат Дата(ДатаНачальная + Подписчик.ПаузаМеждуПопыткамиОбработки);
КонецФункции

// Процедура - Выполнить пост обработку
//
// Параметры:
//  Подписчик        - СправочникСсылка.инт_Подписчики - ссылка на подписчика   
//  Ответ			 - ПодготовленныйОтвет	 - См. инт_КоннекторHTTP.ВызватьМетод
//  ИсходныеДанные	 - ОпределяемыйТип.инт_ИсходныеДанные	 - Ссылка на исходные данные сообщения.
//
Процедура ВыполнитьПостОбработку(Подписчик, Ответ, ИсходныеДанные=Неопределено) Экспорт

	Код = ПолучитьОбработчикПоКодуСостояния(Ответ.КодСостояния, Подписчик);

	Попытка
        Исполнить(Код, Ответ, ИсходныеДанные, Истина);
    Исключение
        ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()); // BSLLS:DeprecatedMethods8317-off
        СообщениеОбОшибке = СтрШаблон("При пост-обработке ответа возникла ошибка!
        |
        | Информация об ошибке: %1",
        ПредставлениеОшибки);
        
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.Подписчики.ПостОбработкаОтвета",
                                    УровеньЖурналаРегистрации.Ошибка,
                                    ,
                                    ,
                                    СообщениеОбОшибке);
        ВызватьИсключение;
    КонецПопытки;

КонецПроцедуры

// Функция - Получить структуру аутентификации подписчика
//
// Параметры:
//  Подписчик	 - СпраочникСсылка.инт_Подписчики - ссылка на подписчика
// 
// Возвращаемое значение:
// Структура - Структура Аутентификации для сессии коннектора HTTP
//
Функция ПолучитьСтруктуруАутентификацииПодписчика(Подписчик) Экспорт
	
	УстановитьПривилегированныйРежим(Истина); // BSLLS:SetPrivilegedMode-off
	Пароль = ИТКВ_БСП.ПрочитатьДанныеИзБезопасногоХранилища(Подписчик);
	УстановитьПривилегированныйРежим(Ложь);
	
	Аутентификация = Новый Структура("Пользователь, Пароль", Подписчик.Пользователь, Пароль);
	
	Возврат Аутентификация;
	
КонецФункции
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьОбработчикПоКодуСостояния(КодСостояния, Подписчик)
	Обработчик = "";
	Подписчик = Справочники.инт_Подписчики.СоздатьЭлемент();
	ПостПроцессинг = Подписчик.ПостПроцессинг;
	СтрокаПостПроцессинга = ПостПроцессинг.Найти(КодСостояния, "КодСостояния");
	
	Если Не СтрокаПостПроцессинга = Неопределено Тогда
		Обработчик = СтрокаПостПроцессинга.Обработчик;
	Иначе
		Обработчик = ПолучитьОбработчикПоУмолчанию(КодСостояния);
	КонецЕсли;
	
	Возврат Обработчик;
КонецФункции

Функция ПолучитьОбработчикПоУмолчанию(КодСостояния)
	Обработчик = "";
	// Здесь через ИНачеЕсли можно определить базовое поведение для разных кодов состояний. 
    // Если их будет много - вынести в регистр
	Если Не (КодСостояния >= 200 И КодСостояния < 300) Тогда // BSLLS:MagicNumber-off ну коды http-то все знают
		Обработчик = "СообщениеОбОшибке = СтрШаблон(""При попытке отправки сообщения код ответа отличается от ожидаемого!
			|	|Код состояния: %1
			|	|ТелоОтвета: %2"", Ответ.КодСостояния, ПолучитьСтрокуИзДвоичныхДанных(Ответ.Тело));
	    	|ВызватьИсключение Строка(Ответ.Тело);";
	КонецЕсли;
	Возврат Обработчик;
КонецФункции

Процедура Исполнить(Код, Ответ, ИсходныеДанные, РазрешитьФиксациюИзменений = Ложь)
    // Проверки в процедуре отключены, т.к. это запланированное поведение.  
    УстановитьБезопасныйРежим(Истина);
    НачатьТранзакцию();
    Попытка
        // BSLLS:ExecuteExternalCodeInCommonModule-off
        Выполнить(Код);
        // BSLLS:ExecuteExternalCodeInCommonModule-on
        Если РазрешитьФиксациюИзменений Тогда
            ЗафиксироватьТранзакцию(); // BSLLS:CommitTransactionOutsideTryCatch-off
        Иначе
           //Для исходящих потоков или проверок фиксация изменений не нужна. 
           ОтменитьТранзакцию(); // BSLLS:WrongUseOfRollbackTransactionMethod-off
        КонецЕсли;
        
    Исключение
        ОтменитьТранзакцию(); // BSLLS:PairingBrokenTransaction-off
        ВызватьИсключение;
    КонецПопытки;
    УстановитьБезопасныйРежим(Ложь); // BSLLS:DisableSafeMode-off
        
КонецПроцедуры

#КонецОбласти

#КонецЕсли
