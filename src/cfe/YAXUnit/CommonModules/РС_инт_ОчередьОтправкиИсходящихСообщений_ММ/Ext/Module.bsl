﻿// BSLLS-off
// @strict-types
/////////////////////////////////////////////////////////////////////////////////
// Экспортные процедуры и функции, предназначенные для использования другими 
// объектами конфигурации или другими программами
///////////////////////////////////////////////////////////////////////////////// 

#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт

    ЮТТесты.УдалениеТестовыхДанных().ВТранзакции()
        .ДобавитьТест("РегистрацияСообщенияПодписчику")
        .ДобавитьТест("ПередачаПустогоПодписчикаВызываетОшибку")
            .Представление("Тест на неопределено", Истина)
            .СПараметрами(Неопределено)
            .Представление("Тест на пустую ссылку", Истина)
            .СПараметрами(Справочники.инт_Подписчики.ПустаяСсылка())
        .ДобавитьТест("РегистрацияСообщенияНесколькимПодписчикам")
		.ДобавитьТест("ТестФормированияСообщения")
			.Представление("Тест подписчика RabbitMQ", Истина)
			.СПараметрами(Перечисления.инт_ТипыПодписчиков.RabbitMQ, "{""text"": ""hello from mock!""}")
			.Представление("Тест подписчика ПодсистемаИнтеграции", Истина)
			.СПараметрами(Перечисления.инт_ТипыПодписчиков.ПодсистемаИнтеграции, "{""text"": ""hello from mock!""}")
			.Представление("Тест подписчика ПроизвольныйHTTP", Истина)
			.СПараметрами(Перечисления.инт_ТипыПодписчиков.ПроизвольныйHTTP, "{""text"": ""hello from mock!""}")
			.Представление("Тест подписчика JRPC2", Истина)
			.СПараметрами(Перечисления.инт_ТипыПодписчиков.JRPC2, "{""text"": ""hello from mock!""}")
        .ДобавитьТест("ТестОтправкиСообщения");
КонецПроцедуры

#Область События

Процедура ПередВсемиТестами() Экспорт

КонецПроцедуры

Процедура ПередКаждымТестом() Экспорт

КонецПроцедуры

Процедура ПослеКаждогоТеста() Экспорт

КонецПроцедуры

Процедура ПослеВсехТестов() Экспорт

КонецПроцедуры

#КонецОбласти

Процедура РегистрацияСообщенияПодписчику() Экспорт
	ИдентификаторСообщения = Новый УникальныйИдентификатор;
    Подписчик = ГенераторТестовыхДанных.Подписчик();
    РегистрыСведений.инт_ОчередьОтправкиИсходящихСообщений.ЗарегистрироватьСообщениеКРассылкеПодписчику(ИдентификаторСообщения, Подписчик);
    
    УсловиеПоискаЗаписи = ЮТест.Предикат() // В базе есть записаное сообщение в очереди со статусом "Новый"
            .Реквизит("Подписчик").Равно(Подписчик)
            .Реквизит("ИдентификаторСообщения").Равно(ИдентификаторСообщения);

    ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.инт_ОчередьОтправкиИсходящихСообщений")
        .СодержитЗаписи(УсловиеПоискаЗаписи);
            
    ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.инт_ТекущийСтатусРассылкиСообщений")
        .СодержитЗаписи(УсловиеПоискаЗаписи);
        
    ЗаписьСтатуса = ЮТЗапросы.Запись("РегистрСведений.инт_ТекущийСтатусРассылкиСообщений", УсловиеПоискаЗаписи);
    ЮТест.ОжидаетЧто(ЗаписьСтатуса, "Запись статуса")
        .Заполнено()
            .Свойство("СтатусСообщения").Заполнено().Равно(Перечисления.инт_СтатусыРассылкиИсходящихСообщений.Новый);
КонецПроцедуры

Процедура ПередачаПустогоПодписчикаВызываетОшибку(Подписчик) Экспорт
	ИдентификаторСообщения = Новый УникальныйИдентификатор;

    ЮТест.ОжидаетЧто(РегистрыСведений.инт_ОчередьОтправкиИсходящихСообщений)
            .Метод("ЗарегистрироватьСообщениеКРассылкеПодписчику")
                .Параметр(ИдентификаторСообщения)
                .Параметр(Подписчик)
                .ВыбрасываетИсключение("Подписчик не заполнен!");
КонецПроцедуры
            
Процедура РегистрацияСообщенияНесколькимПодписчикам() Экспорт
	ИдентификаторСообщения = Новый УникальныйИдентификатор;
    МассивПодписчиков = Новый Массив;
    Для сч = 0 По 2 Цикл
        МассивПодписчиков.Добавить(ГенераторТестовыхДанных.Подписчик());
    КонецЦикла;
    
    РегистрыСведений.инт_ОчередьОтправкиИсходящихСообщений.ЗарегистрироватьСообщениеКРассылкеПодписчикам(ИдентификаторСообщения, МассивПодписчиков);
    
    Для сч=0 По 2 Цикл
     УсловиеПоискаЗаписи = ЮТест.Предикат() // В базе есть записаное сообщение в очереди со статусом "Новый"
            .Реквизит("Подписчик").Равно(МассивПодписчиков[сч])
            .Реквизит("ИдентификаторСообщения").Равно(ИдентификаторСообщения);

    ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.инт_ОчередьОтправкиИсходящихСообщений")
        .СодержитЗаписи(УсловиеПоискаЗаписи);
            
    ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.инт_ТекущийСтатусРассылкиСообщений")
        .СодержитЗаписи(УсловиеПоискаЗаписи);
        
    ЗаписьСтатуса = ЮТЗапросы.Запись("РегистрСведений.инт_ТекущийСтатусРассылкиСообщений", УсловиеПоискаЗаписи);
    ЮТест.ОжидаетЧто(ЗаписьСтатуса, "Запись статуса")
        .Заполнено()
            .Свойство("СтатусСообщения").Заполнено().Равно(Перечисления.инт_СтатусыРассылкиИсходящихСообщений.Новый);
    КонецЦикла;
КонецПроцедуры

Процедура ТестФормированияСообщения(ТипПодписчика, ЭталонноеСообщение) Экспорт
    Сообщение = Новый Структура("ИдентификаторСообщения, Подписчик", Новый УникальныйИдентификатор, ГенераторТестовыхДанных.Подписчик(ТипПодписчика));
    
    Мокито.Обучение(РегистрыСведений.инт_ОчередьИсходящихСообщений)
           .Когда("ПолучитьДанныеОчередиПоИдентификатору").Вернуть(Новый Структура("СформированноеСообщение"))
           .Обучение(Справочники.инт_Подписчики, Истина)
           .Когда("СформироватьСообщениеПоПодписчику").Вернуть(ЭталонноеСообщение)
    .Прогон();
    
    РегистрыСведений.инт_ОчередьОтправкиИсходящихСообщений.СформироватьСообщение(Сообщение);

    УсловиеПоискаЗаписи = ЮТест.Предикат()
           .Реквизит("Подписчик").Равно(Сообщение.Подписчик)
           .Реквизит("ИдентификаторСообщения").Равно(Сообщение.ИдентификаторСообщения);
                    
   ЗаписьСообщения = ЮТЗапросы.Запись("РегистрСведений.инт_ОчередьОтправкиИсходящихСообщений", УсловиеПоискаЗаписи);
   ЮТест.ОжидаетЧто(ЗаписьСообщения, "Запись сообщения")
       .Заполнено()
           .Свойство("СформированноеСообщение").Заполнено().Равно(ЭталонноеСообщение);
КонецПроцедуры

Процедура ТестОтправкиСообщения() Экспорт
     Сообщение = Новый Структура("ИдентификаторСообщения, Подписчик", Новый УникальныйИдентификатор, ГенераторТестовыхДанных.Подписчик());
          
     Мокито.Обучение(Справочники.инт_Подписчики)
           .Когда("ОтправитьСообщение").Пропустить()
		   .Обучение(РегистрыСведений.инт_ОчередьИсходящихСообщений, Истина)
		   .Когда("ПолучитьДанныеОчередиПоИдентификатору").Вернуть(Новый Структура("ПотокДанных", ГенераторТестовыхДанных.ПотокДанныхИсходящий()))
     .Прогон();
     РегистрыСведений.инт_ТекущийСтатусРассылкиСообщений.ЗаписатьСтатусСообщения(Сообщение.ИдентификаторСообщения,Сообщение.Подписчик, Перечисления.инт_СтатусыРассылкиИсходящихСообщений.Новый);
     РегистрыСведений.инт_ОчередьОтправкиИсходящихСообщений.ОтправитьСообщение(Сообщение);
     
     УсловиеПоискаЗаписи = ЮТест.Предикат()
            .Реквизит("Подписчик").Равно(Сообщение.Подписчик)
            .Реквизит("ИдентификаторСообщения").Равно(Сообщение.ИдентификаторСообщения);

    ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.инт_ТекущийСтатусРассылкиСообщений")
        .СодержитЗаписи(УсловиеПоискаЗаписи);
        
    ЗаписьСтатуса = ЮТЗапросы.Запись("РегистрСведений.инт_ТекущийСтатусРассылкиСообщений", УсловиеПоискаЗаписи);
    ЮТест.ОжидаетЧто(ЗаписьСтатуса, "Запись статуса")
        .Заполнено()
            .Свойство("СтатусСообщения").Заполнено().Равно(Перечисления.инт_СтатусыРассылкиИсходящихСообщений.Отправлен);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
