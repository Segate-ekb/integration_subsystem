﻿///////////////////////////////////////////////////////////////////////////////
// инт_РаботаССообщениямиПодсистемаИнтеграции
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция - Сформировать сообщение по подписчику
//
// Параметры:
//  ДанныеСообщения        - Соответствие                   - Соответствие содержащее данные для сериализации
//  Подписчик              - СправочникСсылка.инт_Подписчики - Ссылка на подписчика
//  ИдентификаторСообщения - УникальныйИдентификатор        - УИД сообщения
// 
// Возвращаемое значение:
//  Строка - Сериализованное, готовое к отправке подписчику сообщение
//
Функция СформироватьСообщениеПоПодписчику(ДанныеСообщения, Подписчик, ИдентификаторСообщения) Экспорт
    // Пока так. 
    // В теории тут могут быть манипуляции с сообщением.
    // Сериализация в xml, подсовывание других параметров сериализации(не знаю, форматы дат-там другие и тд)
    // но пока просто в json для mvp
    Возврат инт_КоннекторHTTP.ОбъектВJson(ДанныеСообщения);
		
КонецФункции

// Процедура - Отправить сообщение подписчику
//
// Параметры:
//  Сообщение     - Структура - Данные сообщения 
//
Процедура ОтправитьСообщение(Сообщение) Экспорт
   // Получим поток данных, он будет необходим для отправки
    ДанныеИсходящегоСообщения = РегистрыСведений
                                    .инт_ОчередьИсходящихСообщений
                                        .ПолучитьДанныеОчередиПоИдентификатору(Сообщение.ИдентификаторСообщения,
                                                                                 "ПотокДанных, ИсходныеДанные");
    ПотокДанных = ДанныеИсходящегоСообщения.ПотокДанных;
    
    // mvp просто пошлем сообщение по конкретному адресу.
    Подписчик = Сообщение.Подписчик;

	СтруктураПараметровСоединения = Справочники.инт_Эндпоинты.СтруктураПараметровСоединения(Подписчик.СсылкаНаСервис);
    url = СтрШаблон("%1/hs/api/v1/%2/%3",
                        СтруктураПараметровСоединения.АдресРесурса,
                        ПотокДанных.Код,
                        Сообщение.ИдентификаторСообщения);

    Ответ = инт_КоннекторHTTP.Post(url, Сообщение.СформированноеСообщение, , СтруктураПараметровСоединения.Сессия);
    
	справочники.инт_Подписчики.ВыполнитьПостОбработку(Подписчик, Ответ, ДанныеИсходящегоСообщения.ИсходныеДанные);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
