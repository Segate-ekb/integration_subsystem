﻿// BSLLS-off
// @strict-types
/////////////////////////////////////////////////////////////////////////////////
// Экспортные процедуры и функции, предназначенные для использования другими 
// объектами конфигурации или другими программами
///////////////////////////////////////////////////////////////////////////////// 

#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт

    ЮТТесты.УдалениеТестовыхДанных().ВТранзакции()
    	.ДобавитьТест("ОбработкаВходящегоСообщенияПоИсходящемуПотоку")
        .ДобавитьТест("ОбработкаАсинхронногоСообщения")
        .ДобавитьТест("ОбработкаСообщенияССинхроннойОбработкой");

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

Процедура ОбработкаВходящегоСообщенияПоИсходящемуПотоку() Экспорт
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхИсходящий();
    Сообщение = Новый Соответствие;
    
    ЮТест.ОжидаетЧто(инт_ОбработкаВходящихПотоков)
    .Метод("ОбработкаВходящегоСообщенияПоПотоку")
    .Параметр(Сообщение)
    .Параметр(ПотокДанных)
    .ВыбрасываетИсключение("Нельзя использовать исходящие потоки для входящих сообщений!");
КонецПроцедуры

Процедура ОбработкаАсинхронногоСообщения() Экспорт
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхВходящий();

    Сообщение = Новый Соответствие;
    
    Мокито.Обучение(РегистрыСведений.инт_ОчередьВходящихСообщений)
        .Когда("ЗарегистрироватьСообщение").Пропустить()
        .Прогон();
                
    ЮТест.ОжидаетЧто(инт_ОбработкаВходящихПотоков)
        .Метод("ОбработкаВходящегоСообщенияПоПотоку")
        .Параметр(Сообщение)
        .Параметр(ПотокДанных)
        .НеВыбрасываетИсключение();
КонецПроцедуры

Процедура ОбработкаСообщенияССинхроннойОбработкой() Экспорт
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхВходящий(,,,,Ложь);

    Сообщение = Новый Соответствие;
    
    Мокито.Обучение(Справочники.инт_ПотокиДанных)
        .Когда("ОбработатьВходящееСообщениеПоПотоку").Пропустить()
        .Прогон();
                
    ЮТест.ОжидаетЧто(инт_ОбработкаВходящихПотоков)
        .Метод("ОбработкаВходящегоСообщенияПоПотоку")
        .Параметр(Сообщение)
        .Параметр(ПотокДанных)
        .НеВыбрасываетИсключение();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
