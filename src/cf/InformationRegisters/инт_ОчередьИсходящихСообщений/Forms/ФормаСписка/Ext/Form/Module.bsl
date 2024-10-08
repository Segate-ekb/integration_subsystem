﻿
&НаСервере
Процедура СписокПриАктивизацииСтрокиНаСервере(ИдентификаторСообщения)
	
	СписокОтправка.Параметры.УстановитьЗначениеПараметра("ИдентификаторСообщения", ИдентификаторСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
		
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторСообщения = Элемент.ТекущиеДанные.ИдентификаторСообщения;
	
	СписокПриАктивизацииСтрокиНаСервере(ИдентификаторСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	Элементы.СписокОткрытьДетальнуюИнформацию.Пометка = Ложь;
	
	ОбновитьВидимостьГруппыДетальнаяИнформация();
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьСтатусНаСервере(Статус, ИдентификаторСообщения, ТекстОшибки)
		
    РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Статус, ТекстОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтатус(Команда)
			
	ОткрытьФорму("Перечисление.инт_СтатусыИсходящихСообщений.ФормаВыбора",,,,,,
				Новый ОписаниеОповещения("ИзменитьСтатусЗавершение", ЭтотОбъект));
									
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтатусЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьСтатусНаСервере(ВыбранныйЭлемент,
							Элементы.Список.ТекущиеДанные.ИдентификаторСообщения,
							Элементы.Список.ТекущиеДанные.ТекстОшибки);
	
	Элементы.Список.Обновить();
	
	СписокПриАктивизацииСтроки(Элементы.Список);
								
КонецПроцедуры

&НаКлиенте
Процедура ИсторияСтатусов(Команда)
		
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ИдентификаторСообщения", Элементы.Список.ТекущиеДанные.ИдентификаторСообщения);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("РегистрСведений.инт_ИсторияСтатусовИсходящихСообщений.ФормаСписка", ПараметрыФормы, ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДетальнуюИнформацию(Команда)
	
	Элементы.СписокОткрытьДетальнуюИнформацию.Пометка = НЕ Элементы.СписокОткрытьДетальнуюИнформацию.Пометка;
	
	ОбновитьВидимостьГруппыДетальнаяИнформация();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидимостьГруппыДетальнаяИнформация()
	
	Элементы.ГруппаДетальнаяИнформация.Видимость = Элементы.СписокОткрытьДетальнуюИнформацию.Пометка;
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Элементы.ГруппаДетальнаяИнформация.Доступность = Ложь;
	Иначе
		Элементы.ГруппаДетальнаяИнформация.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИдентификаторСообщения", Элемент.ТекущиеДанные.ИдентификаторСообщения);
	СтруктураПараметров.Вставить("КлючЗаписи", ВыбраннаяСтрока);
	СтандартнаяОбработка = Ложь;
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработкаЗакрытияФормыЗаписи", ЭтотОбъект);
	
	ОткрытьФорму("РегистрСведений.инт_ОчередьИсходящихСообщений.ФормаЗаписи", СтруктураПараметров,,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗакрытияФормыЗаписи(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	Элементы.СписокОтправка.Обновить();
	
КонецПроцедуры
