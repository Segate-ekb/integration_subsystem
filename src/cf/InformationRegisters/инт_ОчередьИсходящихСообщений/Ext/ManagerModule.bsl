﻿////////////////////////////////////////////////////////////////////////////////

// <ОчередьИсходящихСообщений>

//  

////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция - Зарегистрировать сообщение
//
// Параметры:
//  ИсходныеДанные			 - ОпределяемыйТип.инт_ИсходныеДанные	 - Ссылка на объект, или же фиксированная структура содержащая исходные данные для формирования сообщения
//  ПотокДанных				 - СправочникСсылка.инт_ПотокиДанных	 - Ссылка на поток данных.
//  НеРегистрироватьДубль	 - Булево								 - Признак фильтрации дублей. Если ИсходныеДанные не поменялись с прошлой регистрации, или сообщение еще не было сформировано, то дубль регистрироваться не будет. 
// 
// Возвращаемое значение:
//  УникальныйИдентификатор, Неопределено - Возвращает идентификатор сообщения, или неопределено, если что-то пошло не так. 
//
Функция ЗарегистрироватьСообщение(ИсходныеДанные, ПотокДанных, РегистрироватьДубль = Ложь) Экспорт
   ИдентификаторСообщения = Неопределено;
    Если НЕ ПотокДанных.Активен Тогда
        // Поток не активен. Регистрация не будет работать.
    	Возврат ИдентификаторСообщения;
    КонецЕсли;
    Если Не ПотокДанных.НаправлениеПотока = Перечисления.инт_НаправлениеПотокаДанных.Исходящий Тогда
        СообщениеОбОшибке = СтрШаблон("При регистрации сообщения по потоку <%1>, для исходных данных <%2> произошла ошибка!
        |
        | Информация об ошибке: %3",ПотокДанных.Код, ИсходныеДанные, "Нельзя регистрировать в очереди исходящих сообщений входящие потоки!");
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.ОчередьИсходящихСообщений",УровеньЖурналаРегистрации.Ошибка,,ИсходныеДанные,СообщениеОбОшибке);
        Возврат ИдентификаторСообщения;
	КонецЕсли;

	Отказ = Ложь;
    НачатьТранзакцию();
    Попытка
		РегистрыСведений.инт_ХешиОбъектов.ЗаписатьХэшОбъекта(ИсходныеДанные,ПотокДанных, Отказ);
		Если НЕ Отказ ИЛИ РегистрироватьДубль Тогда
			ИдентификаторСообщения = Новый УникальныйИдентификатор;
	        Запись = РегистрыСведений.инт_ОчередьИсходящихСообщений.СоздатьМенеджерЗаписи();
	        Запись.ИдентификаторСообщения = ИдентификаторСообщения;
	        Запись.ПотокДанных = ПотокДанных;
	        Запись.ИсходныеДанные = ИсходныеДанные;
	        Запись.Записать();

	        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(Запись.ИдентификаторСообщения, Перечисления.инт_СтатусыИсходящихСообщений.Новый);
		КонецЕсли;
        ЗафиксироватьТранзакцию();
    Исключение
        ОтменитьТранзакцию();
        СообщениеОбОшибке = СтрШаблон("При регистрации сообщения по потоку <%1>, для исходных данных <%2> произошла ошибка!
        |
        | Информация об ошибке: %3",ПотокДанных.Код, ИсходныеДанные, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.ОчередьИсходящихСообщений",УровеньЖурналаРегистрации.Ошибка,,ИсходныеДанные,СообщениеОбОшибке);
        // Нельзя вызывать исключение, т.к. Это исключение может улететь напрямую пользователю и сломать ему запись!
        Возврат ИдентификаторСообщения;
    КонецПопытки;
    
    Возврат ИдентификаторСообщения;
КонецФункции

// Процедура - Удалить сообщение из очереди по идентификатору
// Удаляет из очереди сообщение, а так же всю связанную с ним информацию из смежных регистров.
// Параметры:
//  ИдентификаторСообщения	 - УникальныйИдентификатор	- Уникальный идентификатор сообщения. 
//
Процедура УдалитьСообщениеИзОчередиПоИдентификатору(ИдентификаторСообщения) Экспорт

	НачатьТранзакцию();
	Попытка
		РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.УдалитьЗаписьПоИдентификатору(ИдентификаторСообщения);
		РегистрыСведений.инт_ИсторияСтатусовИсходящихСообщений.ОчиститьИсториюПоИдентификатору(ИдентификаторСообщения);
		РегистрыСведений.инт_ОчередьОтправкиИсходящихСообщений.УдалитьИзСообщениеИзОчереди(ИдентификаторСообщения);
		
		Запись = РегистрыСведений.инт_ОчередьИсходящихСообщений.СоздатьМенеджерЗаписи();
		Запись.ИдентификаторСообщения = ИдентификаторСообщения;
		Запись.Удалить();
		
		ЗафиксироватьТранзакцию();
	Исключение
	    ОтменитьТранзакцию();
		
		СообщениеОбОшибке = СтрШаблон("При попытке удаления информации о сообщении с идентификатором <%1> возникла ошибка!
		|
		|ИнформацияОбОшибке: %2",
		ИдентификаторСообщения,
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.ОчередьИсходящихСообщений", УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Процедура - Сформировать сообщение по идентификатору
// Формирует сообщение по идентификатору и записывает его в регистр.
//
// Параметры:
//  ИдентификаторСообщения     -   УникальныйИдентификатор   - Идентификатор сообщения которое требуется сформировать.
//
Процедура СформироватьСообщениеПоИдентификатору(ИдентификаторСообщения) Экспорт
    СообщениеВОчереди = ПолучитьДанныеОчередиПоИдентификатору(ИдентификаторСообщения, "ИсходныеДанные,ПотокДанных");
    Попытка
    	СформированноеСообщение = Справочники.инт_ПотокиДанных.СформироватьСообщениеПоПотоку(СообщениеВОчереди.ИсходныеДанные, СообщениеВОчереди.ПотокДанных);
    Исключение
        ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Перечисления.инт_СтатусыИсходящихСообщений.ОшибкаФормирования, ПодробноеПредставлениеОшибки);
        СообщениеОбОшибке = СтрШаблон("При попытке сформировать сообщение с идентификатором <%1> возникла ошибка.
        |
        |Информация об ошибке: %2", ИдентификаторСообщения, ПодробноеПредставлениеОшибки);
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.МенеджерПотоковФормированияСообщений", УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
        ВызватьИсключение СообщениеОбОшибке;
    КонецПопытки;

    НачатьТранзакцию();
    Попытка
        ЗаписатьСформированноеСообщение(ИдентификаторСообщения, СформированноеСообщение);
        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Перечисления.инт_СтатусыИсходящихСообщений.ГотовоКОтправке);
        ЗафиксироватьТранзакцию();
    Исключение
        ОтменитьТранзакцию();
        ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Перечисления.инт_СтатусыИсходящихСообщений.ОшибкаФормирования, ПодробноеПредставлениеОшибки);
        СообщениеОбОшибке = СтрШаблон("При попытке записать сформированное сообщение с идентификатором <%1> возникла ошибка.
        |
        |Информация об ошибке: %2", ИдентификаторСообщения, ПодробноеПредставлениеОшибки);
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.МенеджерПотоковФормированияСообщений", УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
        ВызватьИсключение СообщениеОбОшибке;
    КонецПопытки;
КонецПроцедуры

// Функция - Получить данные очереди по идентификатору
//
// Параметры:
//  ИдентификаторСообщения     -  УникальныйИдентификатор  -  Идентификатор сообщения по которому будут получены данные
//  СписокПолей                 - Строка                    - Строка содержащая перечисления полей перечисленных через запятую.
// 
// Возвращаемое значение:
//  Структура - Структура данных сообщения. См. функцию ПолучитьШаблонСтруктурыСообщенияОчереди
//
Функция ПолучитьДанныеОчередиПоИдентификатору(ИдентификаторСообщения, СписокПолей) Экспорт
	СтруктураСообщения = Новый Структура;
    
    МассивПолей = СтрРазделить(СписокПолей, ",",Ложь);
    Если МассивПолей.Количество() = 0 Тогда
    	ВызватьИсключение "Список полей - не может быть пустым!";
    КонецЕсли;
    ШаблонПоля = "    инт_ОчередьИсходящихСообщений.%1 КАК %1";
    ТекстВыборка = "";
    ЭтоПервоеПоле = Истина;
    Для Каждого Поле Из МассивПолей Цикл
        ТекстВыборка = ТекстВыборка + ?(ЭтоПервоеПоле, "", ",") + Символы.ПС + СтрШаблон(ШаблонПоля, СокрЛП(Поле));
        ЭтоПервоеПоле = Ложь;
    КонецЦикла;
    
    Запрос = Новый Запрос;
    Запрос.Текст = СтрШаблон("ВЫБРАТЬ
                   |    %1
                   |ИЗ
                   |    РегистрСведений.инт_ОчередьИсходящихСообщений КАК инт_ОчередьИсходящихСообщений
                   |ГДЕ
                   |    инт_ОчередьИсходящихСообщений.ИдентификаторСообщения = &ИдентификаторСообщения", ТекстВыборка);
    Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторСообщения);
    Выборка = Запрос.Выполнить().Выбрать();
    Если выборка.Следующий() Тогда
            
        Для Каждого Поле Из МассивПолей Цикл
           	    СтруктураСообщения.Вставить(СокрЛП(Поле), ?(СокрЛП(Поле)="СформированноеСообщение", Выборка[СокрЛП(Поле)].Получить(), Выборка[СокрЛП(Поле)]));
        КонецЦикла;
    КонецЕсли;
    Возврат СтруктураСообщения;
КонецФункции

// Процедура - Зарегистрировать сообщение к отправке
//
// Параметры:
//  ИдентификаторСообщения     -   УникальныйИдентификатор   - Идентификатор сообщения которое требуется отметить к отправке 
//
Процедура ЗарегистрироватьСообщениеКОтправке(ИдентификаторСообщения) Экспорт
    СообщениеВОчереди = ПолучитьДанныеОчередиПоИдентификатору(ИдентификаторСообщения, "ПотокДанных");
    МассивПодписчиков = Справочники.инт_ПотокиДанных.ПолучитьПодписчиковПоПотоку(СообщениеВОчереди.ПотокДанных);
    НачатьТранзакцию();
    Попытка
        РегистрыСведений.инт_ОчередьОтправкиИсходящихСообщений.ЗарегистрироватьСообщениеКРассылкеПодписчикам(ИдентификаторСообщения, МассивПодписчиков);
        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Перечисления.инт_СтатусыИсходящихСообщений.ПомещеноВОчередьОтправки);
        ЗафиксироватьТранзакцию();
    Исключение
        ОтменитьТранзакцию();
        ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
        СообщениеОбОшибке = СтрШаблон("При попытке поместить сообщение с идентификатором <%1> в очередь отправки возникла ошибка.
        |
        |Информация об ошибке: %2", ИдентификаторСообщения, ПодробноеПредставлениеОшибки);
        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Перечисления.инт_СтатусыИсходящихСообщений.ОшибкаОтправки, ПодробноеПредставлениеОшибки);
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.МенеджерПотоковФормированияСообщений", УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
        ВызватьИсключение;
    КонецПопытки;
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьСформированноеСообщение(ИдентификаторСообщения, СформированноеСообщение)
  	Запись = РегистрыСведений.инт_ОчередьИсходящихСообщений.СоздатьМенеджерЗаписи();
    Запись.ИдентификаторСообщения = ИдентификаторСообщения;
    Запись.Прочитать();
    Запись.СформированноеСообщение = Новый ХранилищеЗначения(СформированноеСообщение, Новый СжатиеДанных(9));
    Запись.Записать(Истина);
КонецПроцедуры
  
Функция ПолучитьШаблонСтруктурыСообщенияОчереди()
	Возврат Новый Структура("ИдентификаторСообщения, ИсходныеДанные, ПотокДанных, СформированноеСообщение",
                                            Новый УникальныйИдентификатор,
                                            Неопределено,
                                            Справочники.инт_ПотокиДанных.ПустаяСсылка(),
                                            Новый Соответствие);
КонецФункции
#КонецОбласти

#КонецЕсли
