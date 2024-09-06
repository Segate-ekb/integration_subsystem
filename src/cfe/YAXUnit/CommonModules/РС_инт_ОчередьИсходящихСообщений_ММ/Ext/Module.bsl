﻿// @strict-types

/////////////////////////////////////////////////////////////////////////////////
// Экспортные процедуры и функции, предназначенные для использования другими 
// объектами конфигурации или другими программами
///////////////////////////////////////////////////////////////////////////////// 

#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт
    
    ВариантыПолученияДанныхОчереди = ЮТест.Варианты("ПредставлениеТеста, СписокПолей")
    .Добавить(
      "Одно поле",
      "ИсходныеДанные")
    .Добавить(
      "Несколько полей",
      "ИсходныеДанные,ПотокДанных")
    .Добавить(
      "Несколько полей с пробелами",
      "ИсходныеДанные, ПотокДанных")
    .Добавить(
      "Получение сообщения из хз",
      "СформированноеСообщение")
    .Добавить(
      "Пустая строка",
      "");

  Тесты =  ЮТТесты.УдалениеТестовыхДанных().ВТранзакции()
    	.ДобавитьТест("РегистрацияСообщенияВОчередь")
        .ДобавитьТест("ВходящийПотокНеПопадаетВОчередь")
        .ДобавитьТест("НеактивныйПотокНеПопадаетВОчередь")
        .ДобавитьТест("ФормированиеСообщенияПоПотоку")
        .ДобавитьТест("ПроверкаРассылкиПодписчикам");
    Для Каждого Вариант Из ВариантыПолученияДанныхОчереди.СписокВариантов() Цикл
        Тесты.ДобавитьТест("ПолучениеДанныхОчередиПоИдентификатору")
                .Представление(Вариант.ПредставлениеТеста, Истина)
                .СПараметрами(Вариант.СписокПолей);
	
    КонецЦикла;

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

Процедура РегистрацияСообщенияВОчередь() Экспорт
    ИсходныеДанные = ГенераторТестовыхДанных.демо_Документ();
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхИсходящий();
    ИдентификаторСообщения = РегистрыСведений.инт_ОчередьИсходящихСообщений.ЗарегистрироватьСообщение(ИсходныеДанные, ПотокДанных);
    
    ЮТест.ОжидаетЧто(ИдентификаторСообщения).НеРавно(Неопределено);
    
    УсловиеПоискаЗаписи = ЮТест.Предикат() // В базе есть записаное сообщение в очереди со статусом "Новый"
            .Реквизит("ИдентификаторСообщения").Равно(ИдентификаторСообщения);

    ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.инт_ОчередьИсходящихСообщений")
        .СодержитЗаписи(УсловиеПоискаЗаписи);
        
    ЗаписьСообщения = ЮТЗапросы.Запись("РегистрСведений.инт_ОчередьИсходящихСообщений", УсловиеПоискаЗаписи);
    ЮТест.ОжидаетЧто(ЗаписьСообщения, "Запись сообщения")
        .Заполнено()
            .Свойство("ИсходныеДанные").Заполнено().Равно(ИсходныеДанные)
            .Свойство("ПотокДанных").Заполнено().Равно(ПотокДанных);

    ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.инт_ТекущийСтатусИсходящихСообщений")
        .СодержитЗаписи(УсловиеПоискаЗаписи);
        
    ЗаписьСтатуса = ЮТЗапросы.Запись("РегистрСведений.инт_ТекущийСтатусИсходящихСообщений", УсловиеПоискаЗаписи);
    ЮТест.ОжидаетЧто(ЗаписьСтатуса, "Запись статуса")
        .Заполнено()
            .Свойство("СтатусСообщения").Заполнено().Равно(Перечисления.инт_СтатусыИсходящихСообщений.Новый);
    
КонецПроцедуры
        
Процедура ВходящийПотокНеПопадаетВОчередь() Экспорт
	ИсходныеДанные = ГенераторТестовыхДанных.демо_Документ();
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхВходящий();
    ИдентификаторСообщения = РегистрыСведений.инт_ОчередьИсходящихСообщений.ЗарегистрироватьСообщение(ИсходныеДанные, ПотокДанных);

    ЮТест.ОжидаетЧто(ИдентификаторСообщения).Равно(Неопределено);

КонецПроцедуры
    
Процедура НеактивныйПотокНеПопадаетВОчередь() Экспорт
	ИсходныеДанные = ГенераторТестовыхДанных.демо_Документ();
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхИсходящий(Ложь);
    ИдентификаторСообщения = РегистрыСведений.инт_ОчередьИсходящихСообщений.ЗарегистрироватьСообщение(ИсходныеДанные, ПотокДанных);

    ЮТест.ОжидаетЧто(ИдентификаторСообщения).Равно(Неопределено);

КонецПроцедуры
    
Процедура ФормированиеСообщенияПоПотоку() Экспорт
	ИсходныеДанные = ГенераторТестовыхДанных.демо_Документ();
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхИсходящий();
    // Проверка регистрации выполняется другим тестом.
    ИдентификаторСообщения = РегистрыСведений.инт_ОчередьИсходящихСообщений.ЗарегистрироватьСообщение(ИсходныеДанные, ПотокДанных);
    
    ЮТест.ОжидаетЧто(ИдентификаторСообщения).НеРавно(Неопределено);
    
    СформированноеСообщение = Новый Соответствие;
    СформированноеСообщение.Вставить("Тест", "Тест");
    
    Мокито.Обучение(РегистрыСведений.инт_ОчередьИсходящихСообщений)
            .Когда("ПолучитьДанныеОчередиПоИдентификатору").Вернуть(Новый Структура("ИсходныеДанные,ПотокДанных"))
            .Обучение(Справочники.инт_ПотокиДанных, Истина)
            .Когда("СформироватьСообщениеПоПотоку").Вернуть(СформированноеСообщение)
     .Прогон();
    
    РегистрыСведений.инт_ОчередьИсходящихСообщений.СформироватьСообщениеПоИдентификатору(ИдентификаторСообщения);
    
    Мокито.Сбросить();

    УсловиеПоискаЗаписи = ЮТест.Предикат()
            .Реквизит("ИдентификаторСообщения").Равно(ИдентификаторСообщения);
    ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.инт_ОчередьИсходящихСообщений")
        .СодержитЗаписи(УсловиеПоискаЗаписи);
        
    ЗаписьСообщения = ЮТЗапросы.Запись("РегистрСведений.инт_ОчередьИсходящихСообщений", УсловиеПоискаЗаписи);
    ЮТест.ОжидаетЧто(ЗаписьСообщения, "Запись сообщения")
        .Заполнено()
            .Свойство("СформированноеСообщение").Заполнено();
    ДанныеИсходящегоСообщения = РегистрыСведений.инт_ОчередьИсходящихСообщений.ПолучитьДанныеОчередиПоИдентификатору(ИдентификаторСообщения, "СформированноеСообщение");
    ЮТест.ОжидаетЧто(ДанныеИсходящегоСообщения.СформированноеСообщение).Равно(СформированноеСообщение);
            
   ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.инт_ТекущийСтатусИсходящихСообщений")
        .СодержитЗаписи(УсловиеПоискаЗаписи);
        
    ЗаписьСтатуса = ЮТЗапросы.Запись("РегистрСведений.инт_ТекущийСтатусИсходящихСообщений", УсловиеПоискаЗаписи);
    ЮТест.ОжидаетЧто(ЗаписьСтатуса, "Запись Статуса")
        .Заполнено()
            .Свойство("СтатусСообщения").Заполнено().Равно(Перечисления.инт_СтатусыИсходящихСообщений.ГотовоКОтправке);

КонецПроцедуры

Процедура ПолучениеДанныхОчередиПоИдентификатору(СписокПолей) Экспорт

   	ИсходныеДанные = ГенераторТестовыхДанных.демо_Документ();
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхИсходящий();
    
    // Проверка регистрации выполняется другим тестом.
    ИдентификаторСообщения = РегистрыСведений.инт_ОчередьИсходящихСообщений.ЗарегистрироватьСообщение(ИсходныеДанные, ПотокДанных);
    
    МассивПолей = СтрРазделить(СписокПолей,",",Ложь);
    Если МассивПолей.Количество()=0 Тогда
        ЮТест.ОжидаетЧто(РегистрыСведений.инт_ОчередьИсходящихСообщений)
        .Метод("ПолучитьДанныеОчередиПоИдентификатору")
        .Параметр(ИдентификаторСообщения)
        .Параметр(СписокПолей)
        .ВыбрасываетИсключение("Список полей - не может быть пустым!");
    Иначе
        СтруктураРезультат = РегистрыСведений.инт_ОчередьИсходящихСообщений.ПолучитьДанныеОчередиПоИдентификатору(ИдентификаторСообщения, СписокПолей);
        Для Каждого Поле Из МассивПолей Цикл
            ЮТест.ОжидаетЧто(СтруктураРезультат)
            .Свойство(СокрЛП(Поле));
            Если Поле="СформированноеСообщение" Тогда
                ЮТест.ОжидаетЧто(СтруктураРезультат)
                .Свойство(СокрЛП(Поле)).НеИмеетТип(Тип("ХранилищеЗначения"));
            КонецЕсли;
        КонецЦикла;
    КонецЕсли;
КонецПроцедуры

Процедура ПроверкаРассылкиПодписчикам() Экспорт
	ИсходныеДанные = ГенераторТестовыхДанных.демо_Документ();
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхИсходящий();
    
    // Проверка регистрации выполняется другим тестом.
    ИдентификаторСообщения = РегистрыСведений.инт_ОчередьИсходящихСообщений.ЗарегистрироватьСообщение(ИсходныеДанные, ПотокДанных);
    
    ЮТест.ОжидаетЧто(РегистрыСведений.инт_ОчередьИсходящихСообщений)
        .Метод("ЗарегистрироватьСообщениеКОтправке")
            .Параметр(ИдентификаторСообщения)
            .НеВыбрасываетИсключение();
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
