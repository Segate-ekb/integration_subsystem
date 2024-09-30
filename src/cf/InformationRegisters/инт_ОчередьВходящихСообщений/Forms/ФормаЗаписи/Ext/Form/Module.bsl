﻿#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.КлючЗаписи = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяЗаписьДляФормы = ПолучитьЗаписьРСПоКлючу(Параметры.КлючЗаписи);
	ВходящееСообщениеДЗнач = ФормированиеСообщенияДеревоЗначений(ТекущаяЗаписьДляФормы);

	ЗаписьРСТекущийСтатус = ПолучитьТекущийСтатусПоКлючу(Параметры.КлючЗаписи);

	ЗначениеВРеквизитФормы(ТекущаяЗаписьДляФормы, "Запись");
	ЗначениеВРеквизитФормы(ВходящееСообщениеДЗнач, "ВходящееСообщение");
	ЗначениеВРеквизитФормы(ЗаписьРСТекущийСтатус, "ЗаписьРСТекущийСтатусВходящих");
	
КонецПроцедуры
													
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокОтправка

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьСтатус(Команда)
			
	ОткрытьФорму("Перечисление.инт_СтатусыВходящихСообщений.ФормаВыбора",,,,,,
				Новый ОписаниеОповещения("ИзменитьСтатусЗавершение", ЭтотОбъект));
									
КонецПроцедуры
			
&НаКлиенте
Процедура ИсторияСтатусов(Команда)
		
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ИдентификаторСообщения", Запись.ИдентификаторСообщения);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("РегистрСведений.инт_ИсторияСтатусовВходящихСообщений.ФормаСписка", ПараметрыФормы, ЭтотОбъект);
		
КонецПроцедуры
			
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьТекущийСтатусПоКлючу(КлючЗаписи)
		
	Запись = РегистрыСведений.инт_ТекущийСтатусВходящихСообщений.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, КлючЗаписи);
	Запись.Прочитать();
	
	Если Запись.Выбран() Тогда
		Возврат Запись;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЗаписьРСПоКлючу(КлючЗаписи)
		
	Запись = РегистрыСведений.инт_ОчередьВходящихСообщений.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, КлючЗаписи);
	Запись.Прочитать();
	
	Если Запись.Выбран() Тогда
		Возврат Запись;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ИзменитьСтатусНаСервере(Статус, ИдентификаторСообщения, ТекстОшибки)
		
    РегистрыСведений.инт_ТекущийСтатусВходящихСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Статус, ТекстОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтатусЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьСтатусНаСервере(ВыбранныйЭлемент,
							Запись.ИдентификаторСообщения,
							ЗаписьРСТекущийСтатусВходящих.ТекстОшибки);
										
КонецПроцедуры
						
&НаСервере
Функция ФормированиеСообщенияДеревоЗначений(ТекущаяЗаписьДляФормы)
	
	ВходящееСообщениеСоотв = ТекущаяЗаписьДляФормы.ВходящееСообщение.Получить();
	
	ВходящееСообщениеДЗнач = Новый ДеревоЗначений;
	ВходящееСообщениеДЗнач.Колонки.Добавить("Ключ");
	ВходящееСообщениеДЗнач.Колонки.Добавить("Значение");
	
	ДанныеВДерево(ВходящееСообщениеСоотв, ВходящееСообщениеДЗнач);
	
	Возврат ВходящееСообщениеДЗнач;
	
КонецФункции

&НаСервере
Процедура ДанныеВДерево(Данные, СтрокаДерева)
	
	Если Тип("Соответствие") = ТипЗнч(Данные)
	 ИЛИ Тип("Структура") 	 = ТипЗнч(Данные) Тогда
		ОбработатьОбъект(Данные, СтрокаДерева);
	ИначеЕсли Тип("Массив") = ТипЗнч(Данные) Тогда
        ОбработатьМассив(Данные, СтрокаДерева);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьМассив(Массив, СтрокаДерева)
	
	Для Каждого Элемент Из Массив Цикл
		ПодстрокаДерева		= СтрокаДерева.Строки.Добавить();
		ПодстрокаДерева.Ключ	= ТипЗнч(Элемент);
		Если ЭтоПримитивныйТип(Элемент) Тогда
			ПодстрокаДерева.Значение = Элемент;
		Иначе
			ДанныеВДерево(Элемент, ПодстрокаДерева);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьОбъект(Структура, СтрокаДерева)
	
	Для Каждого Элемент	Из Структура Цикл
		ПодстрокаДерева		= СтрокаДерева.Строки.Добавить();
		ПодстрокаДерева.Ключ	= Элемент.Ключ;
		Если ЭтоПримитивныйТип(Элемент.Значение) Тогда
			ПодстрокаДерева.Значение = Элемент.Значение;
		Иначе
			ДанныеВДерево(Элемент.Значение, ПодстрокаДерева);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ЭтоПримитивныйТип(Значение)
	
	Если Тип("Строка") = ТипЗнч(Значение)
	 ИЛИ Тип("Число")  = ТипЗнч(Значение)
	 ИЛИ Тип("Булево") = ТипЗнч(Значение)
	 ИЛИ Тип("Дата")   = ТипЗнч(Значение) Тогда
	 	Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
		
КонецФункции

#КонецОбласти

