﻿#Область ПрограммныйИнтерфейс

Функция Инициализация(Форма, Имя, Родитель, ДополнительныеСвойства = Неопределено) Экспорт
	
	Если ДополнительныеСвойства = Неопределено Тогда
		ДополнительныеСвойства = Новый Структура;
	КонецЕсли;
	
	ТипЯзыка = ИТКВ_ОбщийКлиентСервер.Свойство(ДополнительныеСвойства, "ТипЯзыка", ИТКВ_Перечисления.ТипЯзыкаРедактораВстроенный());
	РежимКомпоновкиДанных = ИТКВ_ОбщийКлиентСервер.Свойство(ДополнительныеСвойства, "РежимКомпоновкиДанных", Ложь);
	ТолькоПросмотр = ИТКВ_ОбщийКлиентСервер.Свойство(ДополнительныеСвойства, "ТолькоПросмотр", Ложь);
	ВсегдаИспользоватьMonaco = ИТКВ_ОбщийКлиентСервер.Свойство(ДополнительныеСвойства, "ВсегдаИспользоватьMonaco", Ложь);
	
	УстановитьФокус = ИТКВ_ОбщийКлиентСервер.Свойство(ДополнительныеСвойства, "УстановитьФокус", Истина);
	ИспользованиеКоманд = ИТКВ_ОбщийКлиентСервер.Свойство(ДополнительныеСвойства, "ИспользованиеКоманд", Новый Структура);
	Текст = ИТКВ_ОбщийКлиентСервер.Свойство(ДополнительныеСвойства, "Текст");
	Подсказка = ИТКВ_ОбщийКлиентСервер.Свойство(ДополнительныеСвойства, "Подсказка", "");
	Ширина = ИТКВ_ОбщийКлиентСервер.Свойство(ДополнительныеСвойства, "Ширина", 50);
	Высота = ИТКВ_ОбщийКлиентСервер.Свойство(ДополнительныеСвойства, "Высота", 10);
	ФиксированныеНастройки = ИТКВ_ОбщийКлиентСервер.Свойство(ДополнительныеСвойства, "ФиксированныеНастройки", Новый Структура);
	
	Язык = ИТКВ_Общий.КодЯзыкаПрограммирования();
	ИспользуетсяMonaco = ВсегдаИспользоватьMonaco ИЛИ ИспользуетсяMonaco();
	
	// Добавляем элементы
	РедактируетсяКод = НЕ ТолькоПросмотр
							И ТипЯзыка = ИТКВ_Перечисления.ТипЯзыкаРедактораВстроенный();
	Если ИспользуетсяMonaco
			И РедактируетсяКод Тогда
		
		Подсказка = Подсказка + ИТКВ_РедакторКодаКлиентСервер.ПодсказкаПоШаблонам(Язык);
		
	КонецЕсли;
	
	// Элемент Код
	Поля = Новый Структура;
	Поля.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	Поля.Вставить("Ширина", Ширина);
	Поля.Вставить("Высота", Высота);
	Поля.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
	
	ЦветФона = ИТКВ_ОбщийКлиентСервер.ЦветФонаЭлементРедактируется(НЕ ТолькоПросмотр);
	Поля.Вставить("ЦветФона", ЦветФона);
	
	Поля.Вставить("Подсказка", Подсказка);
	Если ЗначениеЗаполнено(Подсказка) Тогда
		Поля.Вставить("ОтображениеПодсказки", ОтображениеПодсказки.Кнопка);
	КонецЕсли;
	
	ДополнительнаяИнформация = Новый Структура;
	ДополнительнаяИнформация.Вставить("Тип", ТипЯзыка);
	ДополнительнаяИнформация.Вставить("РежимКомпоновкиДанных", РежимКомпоновкиДанных);
	ДополнительнаяИнформация.Вставить("ФиксированныеНастройки", ФиксированныеНастройки);
	ДополнительнаяИнформацияJSON = ИТКВ_ОбщийКлиентСервер.КоллекциюВJSONСтроку(ДополнительнаяИнформация);
	Поля.Вставить("ПредупреждениеПриРедактировании", ДополнительнаяИнформацияJSON);
	
	ЭлементКод = Форма.Элементы.Найти(Имя);
	
	ЗаполнитьЗначенияСвойств(ЭлементКод, Поля);
	
	ПрефиксРасширения = ИТКВ_ТуллкитКлиентСервер.Префикс();
	Если ИспользуетсяMonaco Тогда
		
		ЭлементКод.УстановитьДействие("ДокументСформирован", ПрефиксРасширения + "ПодключаемыйДокументСформирован");
		ЭлементКод.УстановитьДействие("ПриНажатии", ПрефиксРасширения + "ПодключаемыйПриНажатии");
		
	Иначе
		
		ЭлементКод.Вид = ВидПоляФормы.ПолеТекстовогоДокумента;
		ЭлементКод.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
		ЭлементКод.УстановитьДействие("ПриИзменении", ПрефиксРасширения + "ПодключаемыйРедакторПриИзменении");
		
		Форма[Имя] = Текст;

	КонецЕсли;
	
	// Добавление общих команд, элементов
	ИнициализироватьЭлементы(Форма, Родитель, ЭлементКод, ТипЯзыка, ИспользуетсяMonaco, ТолькоПросмотр, ИспользованиеКоманд);
	
	Если УстановитьФокус Тогда
		Форма.ТекущийЭлемент = ЭлементКод;
	КонецЕсли;
	
	Возврат ЭлементКод;
		
КонецФункции

Функция ОбработкаСобытияПолученияМетаданных(Объекты) Экспорт
	
	Результат = Новый Массив;
	
	НаборОбъектов = СтрРазделить(Объекты, ",");
	Для Каждого ИмяОбъекта Из НаборОбъектов Цикл
		
		Если СтрНайти(ИмяОбъекта, ".") Тогда
			
			ОписаниеОбъектаМетаданных = ИТКВ_РедакторКодаПовтИсп.ОписаниеОбъектаМетаданных(ИмяОбъекта);
			Если ОписаниеОбъектаМетаданных = Неопределено Тогда
				Прервать;
			КонецЕсли;
			
			ОписаниеМетаданных = ОписаниеОбъектаМетаданных.ОписаниеМетаданных;
			ОбластьОбновления = ОписаниеОбъектаМетаданных.ОбластьОбновления;
			
		Иначе
			
			ИмяКоллекцииMonaco = ИТКВ_РедакторКодаКлиентСерверПовтИсп.ИмяКоллекцииМетаданныхПоТипу(ИмяОбъекта);
			Если ИмяКоллекцииMonaco = Неопределено Тогда
				Прервать;
			КонецЕсли;
			
			ОписаниеМетаданных = ИТКВ_РедакторКодаПовтИсп.ОписаниеСпискаОбъектовМетаданных(ИмяОбъекта);
			ОбластьОбновления = ИмяКоллекцииMonaco + ".items";
			
		КонецЕсли;
		
		ЭлементРезультата = Новый Структура;
		ЭлементРезультата.Вставить("ОписаниеМетаданных", ИТКВ_ОбщийКлиентСервер.КоллекциюВJSONСтроку(ОписаниеМетаданных));
		ЭлементРезультата.Вставить("ОбластьОбновления", ОбластьОбновления);
		
		Результат.Добавить(ЭлементРезультата);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОписаниеПользовательскогоОбъекта(Кэш, ТипЗначения = Неопределено, Свойства = Неопределено) Экспорт
	
	Результат = Новый Структура;
	
	Если ТипЗнч(ТипЗначения) = Тип("Строка") Тогда
		Ссылка = ТипЗначения;
	Иначе
		Ссылка = RefОписания(Кэш, ТипЗначения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Результат.Вставить("ref", Ссылка);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Свойства) Тогда
		
		СвойстваОбъекта = Новый Структура;
		Для Каждого Свойство Из Свойства Цикл
			
			ЗначениеСвойства = Свойство.Значение;
			Если ТипЗнч(ЗначениеСвойства) = Тип("Структура") Тогда
				
				ОписаниеТиповЗначения = Новый ОписаниеТипов;
				Подсказка = ИТКВ_ОбщийКлиентСервер.Свойство(ЗначениеСвойства, "Подсказка");
				
			Иначе
				
				ОписаниеТиповЗначения = ЗначениеСвойства;
				Подсказка = Неопределено;
				
			КонецЕсли;
			
			ОписаниеСвойства = ОписаниеПользовательскогоОбъекта(Кэш, ОписаниеТиповЗначения);
			ОписаниеСвойства.Вставить("name", Свойство.Ключ);
			Если ЗначениеЗаполнено(Подсказка) Тогда
				ОписаниеСвойства.Вставить("description", Подсказка);
			КонецЕсли;
			
			СвойстваОбъекта.Вставить(Свойство.Ключ, ОписаниеСвойства);
			
		КонецЦикла;
		
		Результат.Вставить("properties", СвойстваОбъекта);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОписаниеПоля(Кэш, Поле) Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("name", ПредставлениеПоля(Поле));
	
	СвязьСОбъектом = RefОписания(Кэш, Поле.Тип);
	Если ЗначениеЗаполнено(СвязьСОбъектом) Тогда
		
		Результат.Вставить("ref", СвязьСОбъектом);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИспользуетсяMonaco() Экспорт
	
	Если Не ИТКВ_РедакторКодаКлиентСервер.ПоддерживаетсяПлатформойMonaco() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Настройки = ИТКВ_Настройки.Загрузить();
	Результат = (Настройки["Редактор"] = ИТКВ_Перечисления.РедакторMonaco());
	
	Возврат Результат;
	
КонецФункции

Функция ПользовательскиеОбъектыТекстЗапросаВКонсоли(ЗначенияВнешнихИсточников) Экспорт
	
	Результат = НовыеПользовательскиеОбъекты();
	Кэш = КэшТиповПользовательскихОбъектов();
	
	Для Каждого ОписаниеВнешнегоИсточника Из ЗначенияВнешнихИсточников Цикл
		
		ТаблицаЗначений = ОписаниеВнешнегоИсточника.Значение;
		Если ТаблицаЗначений = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗагрузитьПользовательскиеДанныеПоВнешнемуИсточнику(Результат, Кэш, ОписаниеВнешнегоИсточника.Ключ, ТаблицаЗначений);

	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗагрузитьПользовательскиеДанныеПоВнешнемуИсточнику(Результат, Кэш, ИмяИсточника, Источник) Экспорт
	
	Поля = Новый Структура;
	Для Каждого Поле Из Источник.Колонки Цикл
		
		Поля.Вставить(Поле.Имя, Поле.ТипЗначения);
		
	КонецЦикла;
	
	ОписаниеПолей = ОписаниеПользовательскогоОбъекта(Кэш, , Поля);
	Результат.Вставить(ИмяИсточника, ОписаниеПолей);
	
КонецПроцедуры

Функция ПользовательскиеОбъектыРезультат() Экспорт
	
	Результат = НовыеПользовательскиеОбъекты();
	Кэш = КэшТиповПользовательскихОбъектов();
	
	ИмяПеременнойВозврата = ИТКВ_РедакторКодаКлиентСервер.ИмяПеременнойВозвратаРезультата();
	ДобавитьПользовательскийОбъект(Результат, ИмяПеременнойВозврата);
	
	ИмяПеременнойВозвратаEN = ИТКВ_РедакторКодаКлиентСервер.ИмяПеременнойВозвратаРезультата("en");
	ДобавитьПользовательскийОбъект(Результат, ИмяПеременнойВозвратаEN);
	
	Возврат Результат;
	
КонецФункции

Функция ПользовательскиеОбъектыВыраженияСКД(Контекст) Экспорт
	
	Результат = НовыеПользовательскиеОбъекты();
	Кэш = КэшТиповПользовательскихОбъектов();
	
	ДобавитьДоступныеПоляВыраженияСКД(Результат, Кэш, Контекст.ДоступныеПоля);
	ДобавитьПараметрыВыраженияСКД(Результат, Кэш, Контекст.Параметры);

	Возврат Результат;
	
КонецФункции

Функция ПользовательскиеОбъектыОбработкаРезультатов(Данные, АдресОбрабатываемыхДанных, Имя) Экспорт
	
	Результат = НовыеПользовательскиеОбъекты();
	Кэш = КэшТиповПользовательскихОбъектов();
	
	КодПеред = СтрНайти(Имя, "Перед");
	КодПосле = СтрНайти(Имя, "После");
	ОсновнойКод = Не (КодПосле ИЛИ КодПеред);
	
	// Дополнительные свойства
	ИдентификаторДополнительныеСвойства = ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторДополнительныеСвойства();
	
	ОписаниеОбъектаДополнительныеСвойства = ОписаниеПользовательскогоОбъекта(Кэш, Новый ОписаниеТипов("Структура"));
	ДобавитьПользовательскийОбъект(Результат, ИдентификаторДополнительныеСвойства, ОписаниеОбъектаДополнительныеСвойства);
	
	ИдентификаторДополнительныеСвойстваEN = ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторДополнительныеСвойства("en");
	ДобавитьПользовательскийОбъект(Результат, ИдентификаторДополнительныеСвойстваEN, ОписаниеОбъектаДополнительныеСвойства);
	
	// Параметры
	Параметры = Новый Структура;
	Для Каждого ОписаниеПараметра Из Данные.Параметры Цикл
		Параметры.Вставить(ОписаниеПараметра.Ключ, ОписаниеПараметра.Значение);
	КонецЦикла;
	
	ОписаниеОбъектаПараметры = ОписаниеПользовательскогоОбъекта(Кэш, , Параметры);

	ИдентификаторПараметры = ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторПараметры();
	ДобавитьПользовательскийОбъект(Результат, ИдентификаторПараметры, ОписаниеОбъектаПараметры);
	
	ИдентификаторПараметрыEN = ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторПараметры("en");
	ДобавитьПользовательскийОбъект(Результат, ИдентификаторПараметрыEN, ОписаниеОбъектаПараметры);
	
	// Обрабатываемые данные
	Если КодПеред Тогда
	
		ОписаниеОбъектаОбрабатываемыеДанные = ОписаниеПользовательскогоОбъекта(Кэш, Новый ОписаниеТипов("ТаблицаЗначений"));

		Идентификатор = ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторОбрабатываемыхДанных();
		ДобавитьПользовательскийОбъект(Результат, Идентификатор, ОписаниеОбъектаОбрабатываемыеДанные);
		
		ИдентификаторEN = ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторОбрабатываемыхДанных("en");
		ДобавитьПользовательскийОбъект(Результат, ИдентификаторEN, ОписаниеОбъектаОбрабатываемыеДанные);
		
	КонецЕсли;
	
	// Строка
	Если ОсновнойКод Тогда
		
		Колонки = КолонкиОбрабатываемыхДанных(АдресОбрабатываемыхДанных);
		ОписаниеОбъектаСтрока = ОписаниеПользовательскогоОбъекта(Кэш, , Колонки);
		
		ИдентификаторСтроки = ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторСтроки();
		ДобавитьПользовательскийОбъект(Результат, ИдентификаторСтроки, ОписаниеОбъектаСтрока);
		
		ИдентификаторСтрокиEN = ИТКВ_ОбработкаРезультатаКлиентСервер.ИдентификаторСтроки("en");
		ДобавитьПользовательскийОбъект(Результат, ИдентификаторСтрокиEN, ОписаниеОбъектаСтрока);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НовыеПользовательскиеОбъекты() Экспорт
	
	Возврат Новый Соответствие;
	
КонецФункции

Функция КэшТиповПользовательскихОбъектов() Экспорт
	
	Возврат Новый Соответствие;
	
КонецФункции

Функция ДобавитьПользовательскийОбъект(Объекты, Ключ, Описание = Неопределено) Экспорт
	
	Объекты.Вставить(Ключ, Описание);
	
КонецФункции

Функция КолонкиОбрабатываемыхДанных(Адрес) Экспорт
	
	Результат = Новый Структура;
	
	ОбрабатываемыеДанные = ПолучитьИзВременногоХранилища(Адрес);
	Для Каждого Колонка Из ОбрабатываемыеДанные.Колонки Цикл
		
		Результат.Вставить(Колонка.Имя, Колонка.ТипЗначения);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПримерКодаДляНастроек(Знач КодЯзыка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(КодЯзыка) Тогда
		КодЯзыка = ИТКВ_Общий.КодЯзыкаПрограммированияКонфигурации();
	КонецЕсли;
	
	Результат = НСтр(
	"ru = 'ДополнительныеПараметры = Новый Структура;
	|ДополнительныеПараметры.Вставить(""Имя"", Имя);
	|Если ЗначениеЗаполнено(Путь) Тогда
	|	ДополнительныеПараметры.Вставить(""Путь"", Путь);
	|КонецЕсли;
	|
	|Если ТипЗнч(Объект) = Тип(""СхемаКомпоновкиДанных"") Тогда
	|
	|	ТипОбъекта = ИТКВ_Перечисления.ЭлементДанныхСхемаКомпоновкиДанных();
	|
	|	ДополнительныеПараметры.Вставить(""Настройки"", Параметр1);
	|	ДополнительныеПараметры.Вставить(""ВнешниеНаборыДанных"", Параметр2);
	|
	|Иначе
	|
	|	ТипОбъекта = ИТКВ_Перечисления.ЭлементДанныхЗапрос();
	|
	|КонецЕсли;';
	|en = 'AdditionalParameters = New Structure;
	|AdditionalParameters.Insert(""Name"", Name);
	|If ValueIsFilled(Path) Тогда
	|	AdditionalParameters.Insert(""Path"", Path);
	|EndIf;
	|
	|If TypeOf(Object) = Type(""DataCompositionSchema"") Then
	|
	|	ObjectType = ITK_Enumerations.ItemDataDataCompositionSchema();
	|
	|	AdditionalParameters.Insert(""Settings"", Parameter1);
	|	AdditionalParameters.Insert(""ExternalDataSets"", Parameter2);
	|
	|Else
	|
	|	ObjectType = ITK_Enumerations.ItemDataQuery();
	|
	|EndIf;'", КодЯзыка);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция RefОписания(Кэш, ОписаниеТипов)
	
	Если ОписаниеТипов = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Массив;
	Для Каждого Тип Из ОписаниеТипов.Типы() Цикл
		
		Ref = Кэш.Получить(Тип);
		Если Ref = Неопределено Тогда
			
			Ref = RefТипа(Тип);
			Кэш.Вставить(Тип, Ref);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Ref) Тогда
			Результат.Добавить(Ref);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтрСоединить(Результат, ",");
	
КонецФункции

Функция RefТипа(Тип)
	
	Если Тип = Тип("КонстантыНабор") Тогда
		Возврат "";
	КонецЕсли;
		
	ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		
	Если ОбъектМетаданных = Неопределено Тогда
			
		Результат = RefПростогоТипа(Тип);
			
	Иначе
			
		ИмяОбъектаКоллекцииМетаданных = ИТКВ_Метаданные.ИмяОбъектаКоллекции(ОбъектМетаданных);
		RefКоллекции = ИТКВ_РедакторКодаПовтИсп.RefКоллекции(ИмяОбъектаКоллекцииМетаданных);
		
		Результат = СтрШаблон("%1.%2", RefКоллекции, ОбъектМетаданных.Имя);
			
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция RefПростогоТипа(Тип)
	
	Результат = СоответствиеСтрокаТипRef().Получить(Тип);
	Если Результат = Неопределено Тогда
		Результат = "";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СоответствиеСтрокаТипRef()
	
	Результат = Новый Соответствие;
	Результат.Вставить(Тип("Соответствие"), "classes.Соответствие");
	Результат.Вставить(Тип("Структура"), "classes.Структура");
	Результат.Вставить(Тип("Массив"), "classes.Массив");
	Результат.Вставить(Тип("СтандартныйПериод"), "classes.СтандартныйПериод");
	Результат.Вставить(Тип("ТаблицаЗначений"), "classes.ТаблицаЗначений");
	
	Возврат Результат;
	
КонецФункции

Процедура ИнициализироватьЭлементы(Форма, Родитель, Элемент, ТипЯзыка, ИспользуетсяMonaco, ТолькоПросмотр, ИспользованиеКоманд)
	
	Если ИспользованиеКоманд = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ПрефиксРасширения = ИТКВ_ТуллкитКлиентСервер.Префикс();
	
	Имя = Элемент.Имя;
	ИмяДействия = ПрефиксРасширения + "ПодключаемаяКомандаРедакторКодаОбработчик";
	
	ТекстРедактируется = НЕ ТолькоПросмотр;
	РедактируетсяКод = (ТипЯзыка = ИТКВ_Перечисления.ТипЯзыкаРедактораВстроенный());
	РедактируетсяЗапрос = (ТипЯзыка = ИТКВ_Перечисления.ТипЯзыкаРедактораЗапросы());
	РедактируетсяXML = (ТипЯзыка = ИТКВ_Перечисления.ТипЯзыкаРедактораXML());
	РедактируетсяВыражениеСКД = (ТипЯзыка = ИТКВ_Перечисления.ТипЯзыкаРедактораВыраженияСКД());
	
	// Использование команд
	ИспользуетсяКонструктор = ИТКВ_ОбщийКлиентСервер.Свойство(ИспользованиеКоманд, "Конструктор", Истина);
	ИспользуетсяКонструкторВыделенного = ИТКВ_ОбщийКлиентСервер.Свойство(ИспользованиеКоманд, "КонструкторВыделенного", Истина);
	ИспользуетсяПреобразоватьВоВложенный = ИТКВ_ОбщийКлиентСервер.Свойство(ИспользованиеКоманд, "ПреобразоватьВоВложенный", Истина);
	ИспользуетсяВставкаПредопределенного = ИТКВ_ОбщийКлиентСервер.Свойство(ИспользованиеКоманд, "ВставкаПредопределенного", Истина);
	ИспользуетсяВставкаСсылкиНаОбъектБД = ИТКВ_ОбщийКлиентСервер.Свойство(ИспользованиеКоманд, "ВставкаСсылкиНаОбъектБД", Истина);
	ИспользуетсяУбратьПереносы = ИТКВ_ОбщийКлиентСервер.Свойство(ИспользованиеКоманд, "УбратьПереносы", Истина);
	ИспользуетсяПерейтиКСтроке = ИТКВ_ОбщийКлиентСервер.Свойство(ИспользованиеКоманд, "ПерейтиКСтроке", Истина);
	
	ИмяКонтекстногоМеню = Имя + "КонтекстноеМеню";
	
	// Группа работа с буфером
	ИмяКонтекстногоМенюРаботаСБуфером = ИмяКонтекстногоМеню + "ГруппаРаботаСБуфером";
	КонтекстноеМенюГруппаРаботаСБуфероме = ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюРаботаСБуфером, "Группа", , Элемент.КонтекстноеМеню);
	
	Если ТекстРедактируется Тогда
		
		ИмяКоманды = Имя + "_Вырезать";
		
		ПараметрыКоманды = Новый Структура;
		ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_ВырезатьВБуферОбмена);
		ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.X, , Истина));
		ЗаголовокКоманды = НСтр("ru = 'Вырезать'; en = 'Cut'");
		ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
		
		Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
		ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюРаботаСБуфером + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаРаботаСБуфероме);
		
	КонецЕсли;
	
	ИмяКоманды = Имя + "_Копировать";
	
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_КопироватьВБуферОбмена);
	ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.C, , Истина));
	ЗаголовокКоманды = НСтр("ru = 'Копировать'; en = 'Copy'");
	ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
	
	Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
	ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюРаботаСБуфером + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаРаботаСБуфероме);
	
	Если ТекстРедактируется Тогда
		
		ИмяКоманды = Имя + "_Вставить";
		
		ПараметрыКоманды = Новый Структура;
		ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_ВставитьИзБуфераОбмена);
		ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.V, , Истина));
		ЗаголовокКоманды = НСтр("ru = 'Вставить'; en = 'Paste'");
		ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
		
		Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
		ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюРаботаСБуфером + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаРаботаСБуфероме);
		
	КонецЕсли;
	
	ИмяКоманды = Имя + "_ВыделитьВсе";
	
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.A, , Истина));
	ЗаголовокКоманды = НСтр("ru = 'Выделить все'; en = 'Select all'");
	ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
	
	Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
	ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюРаботаСБуфером + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаРаботаСБуфероме);
	
	Если ТекстРедактируется
			И РедактируетсяЗапрос Тогда
		
		Если ИспользуетсяКонструктор Тогда
			
			// Конструктор запроса
			ИмяКоманды = Имя + "_КонструкторЗапроса";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.КонструкторЗапроса);
			ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.F4));
			ЗаголовокКоманды = НСтр("ru = 'Конструктор...'; en = 'Constructor...'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, Элемент.КонтекстноеМеню);
			
			Если ИспользуетсяКонструкторВыделенного Тогда
				
				// Конструктор выделенного запроса
				ИмяКоманды = Имя + "_КонструкторВыделенногоЗапроса";
				
				ПараметрыКоманды = Новый Структура;
				ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.КонструкторЗапроса);
				ЗаголовокКоманды = НСтр("ru = 'Конструктор (выделенный текст)...'; en = 'Constructor (selected text)...'");
				ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
				
				Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
				ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, Элемент.КонтекстноеМеню);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ИмяКонтекстногоМенюРефакторинг = ИмяКонтекстногоМеню + "ГруппаРефакторинг";
		КонтекстноеМенюГруппаРефакторинг = ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюРефакторинг, "Группа", , Элемент.КонтекстноеМеню);
		
		Если ИспользуетсяПреобразоватьВоВложенный Тогда
			
			// Преобразование запроса во вложенный
			ИмяКоманды = Имя + "_ПреобразоватьВоВложенный";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_ПреобразоватьВоВложенный);
			ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.S, , Истина, Истина));
			ЗаголовокКоманды = НСтр("ru = 'Преобразовать во вложенный...'; en = 'Convert to nested...'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюРефакторинг + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаРефакторинг);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТекстРедактируется
			И РедактируетсяЗапрос Тогда
		
		Если ИспользуетсяВставкаПредопределенного Тогда
			
			ИмяКоманды = Имя + "_ВставкаПредопределенного";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_ПредопределенныйЭлемент);
			ЗаголовокКоманды = НСтр("ru = 'Вставка предопределенного...'; en = 'Insert predefined...'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, Элемент.КонтекстноеМеню);
			
		КонецЕсли;
	
		Если ИспользуетсяУбратьПереносы Тогда
			
			ИмяКоманды = Имя + "_ПереносЗапросаИзКонфигуратора";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_УбратьПереносыСтрок);
			
			ПодсказкаКоманды = НСтр("ru = 'Удаление переносов строк (для вставки запроса из конфигуратора)';
			|en = 'Remove line breaks (to insert a query from the Configurator)'");
			
			ПараметрыКоманды.Вставить("Подсказка", ПодсказкаКоманды);
			
			ЗаголовокКоманды = ИТКВ_Перечисления.Представление(ИТКВ_Перечисления.АлгоритмОбработкиТекстаПереносЗапросаИзКонфигуратора());
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, Элемент.КонтекстноеМеню);
			
		КонецЕсли;
	
	КонецЕсли;
	
	Если ТекстРедактируется
			И РедактируетсяКод Тогда
			
		Если ИспользуетсяКонструктор Тогда
			
			// Конструктор запроса
			ИмяКоманды = Имя + "_КонструкторЗапросаВКоде";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.КонструкторЗапроса);
			ЗаголовокКоманды = НСтр("ru = 'Конструктор запроса...'; en = 'Constructor query...'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, Элемент.КонтекстноеМеню);
		КонецЕсли;
			
		ИмяКоманды = Имя + "_КонструкторФорматнойСтроки";
		ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, НСтр("ru = 'Конструктор форматной строки...'; en = 'Format string constructor...'"));
		
		Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
		ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, Элемент.КонтекстноеМеню);
		
		ИмяКоманды = Имя + "_КонструкторСтрокиНаРазныхЯзыках";
		ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, НСтр("ru = 'Конструктор строк на разных языках...'; en = 'String constructor in different languages ...'"));
		
		Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
		ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, Элемент.КонтекстноеМеню);
		
		Если ИспользуетсяВставкаСсылкиНаОбъектБД Тогда
			
			ИмяКоманды = Имя + "_ВставкаСсылкиНаОбъектБД";
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, НСтр("ru = 'Вставка ссылки на объект БД...'; en = 'Insert a reference to the database object...'"));
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, Элемент.КонтекстноеМеню);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИспользуетсяMonaco Тогда
			
		// Группа Найти/Заменить
		ИмяГруппы = ИмяКонтекстногоМеню + "ГруппаНайтиЗаменить";
		КонтекстноеМенюГруппаНайтиЗаменить = ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяГруппы, "Группа", , Элемент.КонтекстноеМеню);
		
		ИмяКоманды = Имя + "_Найти";
		
		ПараметрыКоманды = Новый Структура;
		ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_Найти);
		ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.F, , Истина));
		ЗаголовокКоманды = НСтр("ru = 'Найти...'; en = 'Find...'");
		ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
		
		Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
		ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяГруппы + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаНайтиЗаменить);
		
		Если ТекстРедактируется Тогда
			
			ИмяКоманды = Имя + "_Заменить";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_Заменить);
			ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.H, , Истина));
			ЗаголовокКоманды = НСтр("ru = 'Заменить...'; en = 'Replace...'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяГруппы + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаНайтиЗаменить);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если РедактируетсяКод ИЛИ РедактируетсяЗапрос Тогда
		
		ИмяКоманды = Имя + "_ПоделитсяЧерезСервисКода";
		
		ПараметрыКоманды = Новый Структура;
		ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_КопироватьВБуферОбмена);
		ЗаголовокКоманды = НСтр("ru = 'Копировать (поделится) через paste1c.ru'; en = 'Copy (share) via paste1c.ru'");
		ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
		
		Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
		ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, Элемент.КонтекстноеМеню);
		
	КонецЕсли;
	
	Если ИспользуетсяMonaco Тогда
		
		Если ИспользуетсяПерейтиКСтроке Тогда
			
			// Перейти к строке...
			ИмяКоманды = Имя + "_ПерейтиКСтроке";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_ПерейтиКСтроке);
			ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.G, , Истина));
			ЗаголовокКоманды = НСтр("ru = 'Перейти к строке...'; en = 'Go to line ...'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, Элемент.КонтекстноеМеню);
			
		КонецЕсли;
		
		Если РедактируетсяКод ИЛИ РедактируетсяЗапрос Тогда
			
			ИмяКоманды = Имя + "_ПерейтиКОпределению";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.F12));
			ЗаголовокКоманды = НСтр("ru = 'Перейти к определению'; en = 'Go to definition'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, Элемент.КонтекстноеМеню);
			
		КонецЕсли;
		
		Если ТекстРедактируется Тогда
			
			ИмяКонтекстногоМенюИзменения = ИмяКонтекстногоМеню + "ГруппаИзменения";
			
			Поля = Новый Структура("Заголовок", НСтр("ru = 'Изменения'; en = 'Changes'"));
			КонтекстноеМенюГруппаИзменения = ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюИзменения, "Подменю", Поля, Элемент.КонтекстноеМеню);
			
			// Анализировать изменения
			ИмяКоманды = Имя + "_АнализироватьИзменения";
			
			ЗаголовокКоманды = НСтр("ru = 'Анализировать...'; en = 'Analyze...'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаИзменения);
			
			// Сбросить изменения
			ИмяКоманды = Имя + "_ЗафиксироватьИзменения";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.C, , Истина, Истина));
			ЗаголовокКоманды = НСтр("ru = 'Зафиксировать'; en = 'Commit'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаИзменения);

		КонецЕсли;
			
	КонецЕсли;
	
	Если ТекстРедактируется
			И (РедактируетсяКод ИЛИ РедактируетсяЗапрос) Тогда
		
		// Группа комментирование
		ИмяКонтекстногоМенюКомментирование = ИмяКонтекстногоМеню + "ГруппаКомментирование";
		
		Поля = Новый Структура("Заголовок", НСтр("ru = 'Комментирование'; en = 'Commenting'"));
		КонтекстноеМенюГруппаКомментирование = ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюКомментирование, "Подменю", Поля, Элемент.КонтекстноеМеню);
		
		ИмяКоманды = Имя + "_ЗакомментироватьТекст";
		
		ПараметрыКоманды = Новый Структура;
		ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_ЗакомментироватьТекст);
		ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.NumDivide, , Истина));
		ЗаголовокКоманды = ИТКВ_Перечисления.Представление(ИТКВ_Перечисления.АлгоритмОбработкиТекстаЗакомментировать());
		ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
		
		Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
		ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюКомментирование + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаКомментирование);
		
		ИмяКоманды = Имя + "_УбратьКомментарииВТексте";
		
		ПараметрыКоманды = Новый Структура;
		ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_УбратьКомментарииВТексте);
		ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.NumDivide, , Истина, Истина));
		ЗаголовокКоманды = ИТКВ_Перечисления.Представление(ИТКВ_Перечисления.АлгоритмОбработкиТекстаУбратьКомментарии());
		ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
		
		Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
		ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюКомментирование + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаКомментирование);
		
	КонецЕсли;
	
	Если ИспользуетсяMonaco Тогда

		Если РедактируетсяКод ИЛИ РедактируетсяЗапрос ИЛИ РедактируетсяXML Тогда
			
			// Группа закладки
			ИмяКонтекстногоМенюЗакладки = ИмяКонтекстногоМеню + "ГруппаЗакладки";
			
			Поля = Новый Структура("Заголовок", НСтр("ru = 'Закладки'; en = 'Bookmarks'"));
			КонтекстноеМенюГруппаЗакладки = ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюЗакладки, "Подменю", Поля, Элемент.КонтекстноеМеню);
			
			ИмяКоманды = Имя + "_УстановитьСнятьЗакладку";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_УстановитьСнятьЗакладку);
			ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.F2, Истина));
			ЗаголовокКоманды = НСтр("ru = 'Установить/снять закладку'; en = 'Set/remove bookmark'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюЗакладки + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаЗакладки);
			
			ИмяКоманды = Имя + "_СледующаяЗакладка";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_СледующаяЗакладка);
			ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.F2));
			ЗаголовокКоманды = НСтр("ru = 'Следующая закладка'; en = 'Next bookmark'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюЗакладки + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаЗакладки);
			
			ИмяКоманды = Имя + "_ПредыдущаяЗакладка";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_ПредыдущаяЗакладка);
			ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.F2, , , Истина));
			ЗаголовокКоманды = НСтр("ru = 'Предыдущая закладка'; en = 'Previous bookmark'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюЗакладки + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаЗакладки);
			
			ИмяКоманды = Имя + "_УдалитьВсеЗакладки";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_УдалитьВсеЗакладки);
			ЗаголовокКоманды = НСтр("ru = 'Удалить все закладки'; en = 'Delete all bookmarks'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюЗакладки + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаЗакладки);
			
		КонецЕсли;

		Если ТекстРедактируется
				И РедактируетсяКод Тогда
			
			ИмяКоманды = Имя + "_Форматировать";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_Форматировать);
			ПараметрыКоманды.Вставить("СочетаниеКлавиш", Новый СочетаниеКлавиш(Клавиша.F, Истина, , Истина));
			ЗаголовокКоманды = НСтр("ru = 'Форматировать'; en = 'Format'");
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМеню + ИмяКоманды, "Кнопка", Поля, Элемент.КонтекстноеМеню);
		
			// Группа добавить/убрать переносы строк
			ИмяГруппыПереносы = ИмяКонтекстногоМеню + "ГруппаПереносы";
			КонтекстноеМенюГруппаПереносы = ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяГруппыПереносы, "Группа", , Элемент.КонтекстноеМеню);
			
			ИмяКоманды = Имя + "_ДобавитьПереносыСтрок";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_ДобавитьПереносыСтрок);
			ЗаголовокКоманды = ИТКВ_Перечисления.Представление(ИТКВ_Перечисления.АлгоритмОбработкиТекстаДобавитьПереносыСтрок());
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяГруппыПереносы + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаПереносы);
			
			ИмяКоманды = Имя + "_УбратьПереносыСтрок";
			
			ПараметрыКоманды = Новый Структура;
			ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_УбратьПереносыСтрок);
			ЗаголовокКоманды = ИТКВ_Перечисления.Представление(ИТКВ_Перечисления.АлгоритмОбработкиТекстаУбратьПереносыСтрок());
			ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
			
			Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
			ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяГруппыПереносы + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаПереносы);
			
		КонецЕсли;
		
		// Настройка редактора...
		ИмяКонтекстногоМенюНастройкаРедактора = ИмяКонтекстногоМеню + "ГруппаНастройкаРедактора";
		КонтекстноеМенюГруппаНастройкаРедактора = ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюНастройкаРедактора, "Группа", , Элемент.КонтекстноеМеню);
		
		ИмяКоманды = Имя + "_НастройкаРедактора";
		
		ПараметрыКоманды = Новый Структура;
		ПараметрыКоманды.Вставить("Картинка", БиблиотекаКартинок.ИТКВ_Настройки);
		ЗаголовокКоманды = НСтр("ru = 'Настройка редактора...'; en = 'Configuring the Editor...'");
		ИТКВ_Форма.ДобавитьКоманду(Форма, ИмяКоманды, ИмяДействия, ЗаголовокКоманды, ПараметрыКоманды);
		
		Поля = Новый Структура("ИмяКоманды", ИмяКоманды);
		ИТКВ_Форма.ДобавитьЭлемент(Форма, ИмяКонтекстногоМенюНастройкаРедактора + ИмяКоманды, "Кнопка", Поля, КонтекстноеМенюГруппаНастройкаРедактора);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПредставлениеПоля(Поле)
	
	ПредставлениеПоля = Поле.Синоним;
	Если Не ЗначениеЗаполнено(ПредставлениеПоля) Тогда
		ПредставлениеПоля = Поле.Имя;
	КонецЕсли;
	
	Шаблон = НСтр("ru = '%1
                   |Тип:
                   |%2';
				   |en = '%1
                   |Type:
                   |%2'");
	
	Возврат СтрШаблон(Шаблон, ПредставлениеПоля, ИТКВ_Типы.ПредставлениеОписания(Поле.Тип));
	
КонецФункции

Процедура ДобавитьДоступныеПоляВыраженияСКД(Результат, Кэш, ДоступныеПоля)
	
	Если ДоступныеПоля = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементПоле Из ДоступныеПоля Цикл
		
		Свойства = Новый Структура;
		ТипЗначения = ЭлементПоле.Значение;
		
		Если ТипЗнч(ТипЗначения) = Тип("СписокЗначений") Тогда
			
			Для Каждого ЭлементВложенноеПоле Из ТипЗначения Цикл
				Свойства.Вставить(ЭлементВложенноеПоле.Представление, ЭлементВложенноеПоле.Значение);
			КонецЦикла;
			ТипЗначения = Неопределено;
			
		КонецЕсли;
		
		ОписаниеПоля = ОписаниеПользовательскогоОбъекта(Кэш, ТипЗначения, Свойства);
		ДобавитьПользовательскийОбъект(Результат, ЭлементПоле.Представление, ОписаниеПоля);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьПараметрыВыраженияСКД(Результат, Кэш, Параметры)
	
	Если Параметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Параметр Из Параметры Цикл
		
		ОписаниеПоля = ОписаниеПользовательскогоОбъекта(Кэш, Параметр.Значение);
		ДобавитьПользовательскийОбъект(Результат, "&" + Параметр.Ключ, ОписаниеПоля);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
