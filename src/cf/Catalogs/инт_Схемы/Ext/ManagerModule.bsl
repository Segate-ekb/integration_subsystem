﻿////////////////////////////////////////////////////////////////////////////////
// инт_Схемы
//  
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция - Получить open api схему
//
// Параметры:
//  Схема     - СправочникСсылка.инт_Схемы - Ссылка на справочник схемы данных
// 
// Возвращаемое значение:
//  Строка - OpenApi схема в формате json 
//
Функция ПолучитьOpenApiСхему(Схема) Экспорт
    // Первым делом поймем - актуальна ли наша схема.
    Если Схема.Внешняя И РегистрыСведений.инт_КэшированиеСхемOpenApi.ТребуетсяОбновление(Схема) Тогда
         ОбновитьСхемуИзИсточника(Схема);
    КонецЕсли;
    
    Возврат Схема.ТекстСхемыJson;
КонецФункции
 
// Процедура - Обновляет внешнюю схему из удаленного источника.
//
// Параметры:
//  Схема     - СправочникСсылка.инт_Схемы - Ссылка на справочник схемы данных
//
Процедура ОбновитьСхемуИзИсточника(Схема) Экспорт
    Json = ПолучитьТекстJsonПоСсылкеНаСхему(Схема.СсылкаНаСхему);
    // Если изменений нет - писать не будем
    Если Json = Схема.ТекстСхемыJson Тогда
        РегистрыСведений.инт_КэшированиеСхемOpenApi.ОбновитьДатуКэша(Схема);
        Возврат;
    КонецЕсли;
    
    // ответ какой надо, текст получен. есть изменения. Можно и писать.
    СхемаОбъект = Схема.ПолучитьОбъект();
    СхемаОбъект.ТекстСхемыJson = Json;
    СхемаОбъект.Записать();
    
КонецПроцедуры

// Функция - Получить текст json по ссылке на схему
//
// Параметры:
//  СсылкаНаСхему     - Строка - URL для получения схемы
// 
// Возвращаемое значение:
//  Строка - Строка Json. Схема полученая по ссылке. 
//
Функция ПолучитьТекстJsonПоСсылкеНаСхему(СсылкаНаСхему) Экспорт
    Если НЕ ЗначениеЗаполнено(СсылкаНаСхему) Тогда
    	ВызватьИсключение "Ссылка на схему не заполнена!";
    КонецЕсли;
    
    Ответ = инт_КоннекторHTTP.Get(СсылкаНаСхему);
    Если Не (Ответ.КодСостояния >= 200 И Ответ.КодСостояния < 300)  Тогда
        СообщениеОбОшибке = СтрШаблон("При попытке получения схемы из <%1> возникла ошибка!
        | КодСостояния: %2
        | Ответ: %3", СсылкаНаСхему, Ответ.КодСостояния, ПолучитьСтрокуИзДвоичныхДанных(Ответ.Тело));
    	ВызватьИсключение СообщениеОбОшибке;
    КонецЕсли;
    Json = ПолучитьСтрокуИзДвоичныхДанных(Ответ.Тело);
    Если НЕ ЗначениеЗаполнено(Json) Тогда
        ВызватьИсключение "Не удалось получить Json-схему";
    КонецЕсли;
    Возврат Json;
КонецФункции

// Функция - Массив имен пакетов по схеме
//
// Параметры:
//  Схема     - СправочникСсылка.инт_Схемы - Ссылка на справочник схемы данных
// 
// Возвращаемое значение:
//  Массив - Массив имен пакетов 
//
Функция МассивИменПакетовПоСхеме(Схема) Экспорт
    МассивИмен = Новый Массив;
    Если ЗначениеЗаполнено(Схема) Тогда
        Схемы = инт_ВалидаторПакетовПовтИсп.СхемыДанныхСпецификации(Схема);
        Для Каждого ЭлементСоответствия Из Схемы Цикл
            МассивИмен.Добавить(ЭлементСоответствия.Ключ);
        КонецЦикла;
        
    КонецЕсли;
    Возврат МассивИмен;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли
