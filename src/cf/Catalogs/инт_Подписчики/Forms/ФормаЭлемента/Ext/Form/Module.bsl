﻿////////////////////////////////////////////////////////////////////////////////
// инт_Подписчики
//  
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    ОбновитьВидимостьДоступностьЭлементовФормы();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Справочники.инт_Эндпоинты.ДобавитьИнформациюОбЭндпоинтеНаФорму(ЭтотОбъект,
																	Объект.СсылкаНаСервис,
																		Элементы.ГруппаПараметрыОбщие,
																			"КоличествоПопытокОтправки");
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.СсылкаНаСхему = Справочники.инт_Эндпоинты.СоздатьОбновитьЭндпоинт(ЭтотОбъект,
																					ТекущийОбъект.СсылкаНаСервис);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
  
&НаКлиенте
Процедура ТипПодписчикаПриИзменении(Элемент)
    ОбновитьВидимостьДоступностьЭлементовФормы();
КонецПроцедуры

&НаКлиенте
Процедура АдресРесурсаПриИзменении(Элемент)
	инт_ЭндпоинтыКлиент.АдресРесурсаПриИзменении(ЭтотОбъект["АдресРесурса"], ЭтотОбъект);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТипАвторизацииПриИзменении(Элемент)
	инт_ЭндпоинтыКлиент.ТипАвторизацииПриИзменении(ЭтотОбъект["ТипАвторизации"], ЭтотОбъект);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Basic_ПарольПриИзменении(Элемент)
	Basic_ПарольИзменен = Истина;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Bearer_ТокенПриИзменении(Элемент)
	Bearer_ТокенИзменен = Истина;
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьВидимостьДоступностьЭлементовФормы()
    Элементы.ГруппаПараметрыПроизвольногоHTTP.Видимость =
					Объект.ТипПодписчика =
						ПредопределенноеЗначение("Перечисление.инт_ТипыПодписчиков.ПроизвольныйHTTP"); // BSLLS:Typo-off
КонецПроцедуры

&НаСервере
Процедура ПроверитьОбязательныеПараметрыВСсылкеНаСервис(Отказ)
	Если Объект.СпособПередачиИдентификатораСообщения = Перечисления.инт_СпособыПередачиПараметровПоHTTP.ВПараметреПути
				И СтрНайти(Объект.СсылкаНаСервис, "/{flow_id}") = 0 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "В ссылке на сервис отсутствует требуемый параметр {flow_id}.";
		Сообщение.Поле = "Объект.СсылкаНаСервис";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если Объект.СпособПередачиИдентификатораСообщения = Перечисления.инт_СпособыПередачиПараметровПоHTTP.ВПараметреПути
			И СтрНайти(Объект.СсылкаНаСервис, "/{message_id}") = 0 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "В ссылке на сервис отсутствует требуемый параметр {message_id}.";
		Сообщение.Поле = "Объект.СсылкаНаСервис";
		Сообщение.Сообщить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПостПроцессингОбработчикНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДопПараметры = Новый Структура("ТекстОбработчика", Элемент.ТекстРедактирования);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияРедактированияОбработчика", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.инт_Подписчики.Форма.ФормаРедактированияОбработчика", // BSLLS:Typo-off
					ДопПараметры,
					Элемент,
					,
					,
					,
					ОписаниеОповещения,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияРедактированияОбработчика(ТекстОбработчика, ДополнительныеПараметры) Экспорт
    Если ТекстОбработчика = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Элементы.ПостПроцессинг.ТекущиеДанные.Обработчик = ТекстОбработчика;
КонецПроцедуры

#КонецОбласти
