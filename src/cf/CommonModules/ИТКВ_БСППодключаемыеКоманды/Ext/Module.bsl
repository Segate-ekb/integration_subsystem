﻿#Область ПрограммныйИнтерфейс

Процедура ДополнитьВидыКоманд(Результат) Экспорт
	
	Если НЕ ИТКВ_ИнтеграцияВКонфигурацию.Используется() Тогда
		Возврат;
	КонецЕсли;
	
	// Добавляем наше подменю
	Если ИТКВ_БСП.АнглийскаяБСП() Тогда
		
		ПолеВидГруппыФормы = "FormGroupType";
		ПолеИмя = "Name";
		ПолеИмяПодменю = "SubmenuName";
		ПолеЗаголовок = "Title";
		ПолеКартинка = "Picture";
		ПолеОтображение = "Representation";
		ПолеПолеИмяПодменю = "Order";
		
	Иначе
		
		ПолеВидГруппыФормы = "ВидГруппыФормы";
		ПолеИмя = "Имя";
		ПолеИмяПодменю = "ИмяПодменю";
		ПолеЗаголовок = "Заголовок";
		ПолеКартинка = "Картинка";
		ПолеОтображение = "Отображение";
		ПолеПолеИмяПодменю = "Порядок";
		
	КонецЕсли;
	
	НовыйВидКоманды = Результат.Добавить();
	НовыйВидКоманды[ПолеВидГруппыФормы] = ВидГруппыФормы.Подменю;
	
	ИдентификаторПодменю = ИТКВ_ИнтеграцияВКонфигурациюКлиентСервер.ИдентификаторПодменю();
	НовыйВидКоманды[ПолеИмя] = ИдентификаторПодменю;
	НовыйВидКоманды[ПолеИмяПодменю] = ИдентификаторПодменю;
	
	НовыйВидКоманды[ПолеЗаголовок] = ИТКВ_ТуллкитКлиентСервер.Представление();
	НовыйВидКоманды[ПолеКартинка] = БиблиотекаКартинок.ИТКВ_Подсистема;
	НовыйВидКоманды[ПолеОтображение] = ОтображениеКнопки.Картинка;
	НовыйВидКоманды[ПолеПолеИмяПодменю] = 1000;
	
КонецПроцедуры

Процедура ДополнитьКэшФормы(Результат) Экспорт
	
	Если НЕ ИТКВ_ИнтеграцияВКонфигурацию.Используется() Тогда
		Возврат;
	КонецЕсли;
	
	// Добавляем наши команды
	ИдентификаторПодменю = ИТКВ_ИнтеграцияВКонфигурациюКлиентСервер.ИдентификаторПодменю();
	
	Если ИТКВ_БСП.АнглийскаяБСП() Тогда
		ПолеКоманды = "Commands";
	Иначе
		ПолеКоманды = "Команды";
	КонецЕсли;
	Команды = Результат[ПолеКоманды];
	
	Если ПравоДоступа("Использование", Метаданные.Обработки.ИТКВ_РедакторОбъекта) Тогда
		
		ДобавитьКоманду(Команды, ИдентификаторПодменю, ИТКВ_ПодключаемыеКомандыКлиентСервер.РедакторОбъектаПредставлениеКоманды(),
							"ИТКВ_ИнтеграцияВКонфигурациюКлиент.РедакторОбъекта", 1);
		
	КонецЕсли;
	
	Если ПравоДоступа("Использование", Метаданные.Отчеты.ИТКВ_АнализПравДоступа) Тогда
		
		ДобавитьКоманду(Команды, ИдентификаторПодменю, ИТКВ_ПодключаемыеКомандыКлиентСервер.АнализПравДоступаПредставлениеКоманды(),
							"ИТКВ_ИнтеграцияВКонфигурациюКлиент.АнализПравДоступа", 2, БиблиотекаКартинок.Отчет, Истина);
		
	КонецЕсли;
	
	Если ПравоДоступа("Использование", Метаданные.Отчеты.ИТКВ_СравнениеОбъектов) Тогда
		
		ДобавитьКоманду(Команды, ИдентификаторПодменю, ИТКВ_ПодключаемыеКомандыКлиентСервер.СравнениеОбъектовПредставлениеКоманды(),
							"ИТКВ_ИнтеграцияВКонфигурациюКлиент.СравнениеОбъектов", 3, БиблиотекаКартинок.Отчет, Истина);
		
	КонецЕсли;
	
	Если ПравоДоступа("Использование", Метаданные.Обработки.ИТКВ_ПоискСсылокНаОбъект) Тогда
		
		ДобавитьКоманду(Команды, ИдентификаторПодменю, ИТКВ_ПодключаемыеКомандыКлиентСервер.ПоискСсылокНаОбъектПредставлениеКоманды(),
							"ИТКВ_ИнтеграцияВКонфигурациюКлиент.НайтиСсылкиНаОбъект", 4);
		
	КонецЕсли;
	
	Если ПравоДоступа("Использование", Метаданные.Обработки.ИТКВ_ПоискИЗаменаСсылок) Тогда
		
		ДобавитьКоманду(Команды, ИдентификаторПодменю, ИТКВ_ПодключаемыеКомандыКлиентСервер.ПоискИЗаменаСсылокПредставлениеКоманды(),
							"ИТКВ_ИнтеграцияВКонфигурациюКлиент.ПоискИЗаменаСсылок", 5);

	КонецЕсли;
	
	Если ПравоДоступа("ЖурналРегистрации", Метаданные) Тогда
		
		ДобавитьКоманду(Команды, ИдентификаторПодменю, ИТКВ_ПодключаемыеКомандыКлиентСервер.ЖурналРегистрацииПредставлениеКоманды(),
							"ИТКВ_ИнтеграцияВКонфигурациюКлиент.ЖурналРегистрации", 6, БиблиотекаКартинок.ЖурналРегистрации);
		
	КонецЕсли;
	
	Если ПравоДоступа("Использование", Метаданные.Обработки.ИТКВ_ПодпискиНаСобытия) Тогда
		
		ДобавитьКоманду(Команды, ИдентификаторПодменю, ИТКВ_ПодключаемыеКомандыКлиентСервер.ПодпискиНаСобытияПредставлениеКоманды(),
							"ИТКВ_ИнтеграцияВКонфигурациюКлиент.ПодпискиНаСобытия", 7, БиблиотекаКартинок.ИТКВ_ПодпискаНаСобытие, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьКоманду(Команды, ИдентификаторПодменю, Представление, Обработчик, Порядок, Картинка = Неопределено, МножественныйВыбор = Ложь)
	
	Если ИТКВ_БСП.АнглийскаяБСП() Тогда
		
		РежимЗаписи = "Write";
		
		ПолеВид = "Kind";
		ПолеПредставление = "Presentation";
		ПолеОбработчик = "Handler";
		ПолеКартинка = "Picture";
		ПолеМножественныйВыбор = "MultipleChoice";
		ПолеРежимЗаписи = "WriteMode";
		ПолеИзменяетВыбранныеОбъекты = "ChangesSelectedObjects";
		ПолеПорядок = "Order";
		
	Иначе
		
		РежимЗаписи = "Запись";
		
		ПолеВид = "Вид";
		ПолеПредставление = "Представление";
		ПолеОбработчик = "Обработчик";
		ПолеКартинка = "Картинка";
		ПолеМножественныйВыбор = "МножественныйВыбор";
		ПолеРежимЗаписи = "РежимЗаписи";
		ПолеИзменяетВыбранныеОбъекты = "ИзменяетВыбранныеОбъекты";
		ПолеПорядок = "Порядок";
		
	КонецЕсли;
	
	НоваяКоманда = Команды.Добавить();
	НоваяКоманда[ПолеВид] = ИдентификаторПодменю;
	НоваяКоманда[ПолеПредставление] = Представление;
	НоваяКоманда[ПолеОбработчик] = Обработчик;
	НоваяКоманда[ПолеКартинка] = Картинка;
	НоваяКоманда[ПолеМножественныйВыбор] = МножественныйВыбор;
	НоваяКоманда[ПолеРежимЗаписи] = "Запись";
	НоваяКоманда[ПолеИзменяетВыбранныеОбъекты] = Ложь;
	НоваяКоманда[ПолеПорядок] = Порядок;
	
КонецПроцедуры

#КонецОбласти
