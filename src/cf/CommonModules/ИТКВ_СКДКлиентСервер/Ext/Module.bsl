﻿#Область ПрограммныйИнтерфейс

// Возвращает текст ошибки когда СКД пустая
//
// Возвращаемое значение:
//   Строка	- текст ошибки когда СКД пустая
//
Функция ТекстОшибкиПустаяСхема() Экспорт

	ТекстОшибки = НСтр("ru = 'Ошибка разбора XML:  - [1,1]
	|Фатальная ошибка:
	|Extra content at the end of the document'; en = 'XML parsing error: - [1,1]
	|Fatal error:
	|Extra content at the end of the document'");
	
	Возврат ТекстОшибки;

КонецФункции

// Возвращает информацию о ошибке строки данных
//
// Параметры:
//   ТекстОшибки - Строка - Текст ошибки вида 
//							Ошибка разбора XML:  - [2,4] Фатальная ошибка: Extra content at the end of the document
// Возвращаемое значение:
//   Структура - Информация о ошибке
//   	*Текст - Строка - Текст ошибки
//   	*НомерСтроки - Число - Номер строки
//   	*НомерСтолбца - Число - Номер столбцы
//
Функция ИнформацияООшибке(ТекстОшибки) Экспорт
	
	// Разбирает строку ошибки СКД
	// Например: "Ошибка разбора XML:  - [1,1]
	// Фатальная ошибка: 
	// Document is empty"

	Если ПустаяСтрока(ТекстОшибки) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Индекс = 1;
	ИТКВ_Строки.РазборНайтиТекст(ТекстОшибки, " - [", Индекс);
	НомерСтроки = ИТКВ_Строки.РазборПрочитатьЦелоеЧисло(ТекстОшибки, Индекс);
	ИТКВ_Строки.РазборПропуститьНаборСимволов(ТекстОшибки, ",", Индекс);
	НомерСтолбца = ИТКВ_Строки.РазборПрочитатьЦелоеЧисло(ТекстОшибки, Индекс);
	ИТКВ_Строки.РазборПропуститьНаборСимволов(ТекстОшибки, "]", Индекс);
	ИТКВ_Строки.РазборПрочитатьНезначимые(ТекстОшибки, Индекс);
	Текст = ИТКВ_Строки.РазборПрочитатьДоСимвола(ТекстОшибки, "", Индекс);
	
	Текст = СтрЗаменить(Текст, Символы.ПС, "");
	
	Результат = Новый Структура;
	Результат.Вставить("Текст", Текст);
	Результат.Вставить("НомерСтроки", НомерСтроки);
	Результат.Вставить("НомерСтолбца", НомерСтолбца);
	
	Возврат Результат;
	
КонецФункции

// Возвращает строку фильтра для диалога выбора файла
// Возвращаемое значение:
//   Строку - Фильтр для диалога выбора файла
Функция ФильтрФайловXML() Экспорт
	
	ПоддерживаемыеФорматы = Новый СписокЗначений;
	ПоддерживаемыеФорматы.Добавить("*.xml", НСтр("ru = 'Файл схемы компоновки данных'; en = 'Data layout diagram file'"));
	
	Возврат ИТКВ_ОбщийКлиентСервер.ФильтрФайлов(ПоддерживаемыеФорматы);
	
КонецФункции

Функция ПустоеОписаниеРолиПоляНабораДанных() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ТипПериода", "Основной");
	Результат.Вставить("НомерПериода", 0);
	
	Результат.Вставить("Обязательное", Ложь);
	Результат.Вставить("ИгнорироватьЗначенияNULL", Ложь);
	
	Результат.Вставить("Измерение", Ложь);
	Результат.Вставить("РодительскоеИзмерение", "");
	Результат.Вставить("РеквизитИзмерения", Ложь);
	
	Результат.Вставить("Счет", Ложь);
	Результат.Вставить("ПолеСчета", "");
	Результат.Вставить("ВыражениеВидаСчета", "");
	Результат.Вставить("ТипОстатка", "Нет");
	Результат.Вставить("Остаток", Ложь);
	Результат.Вставить("ГруппаОстатка", "");
	Результат.Вставить("ТипБухгалтерскогоОстатка", "Нет");
	
	Возврат Результат;
	
КонецФункции

Функция ПредставлениеВыраженийУпорядочивания(Значение) Экспорт
	
	ЧастиРезультата = Новый Массив;
	Для Каждого ЭлементВыраженияУпорядочивания Из Значение Цикл
		
		ЧастиВыражения = Новый Массив;
		ЧастиВыражения.Добавить(ЭлементВыраженияУпорядочивания.Представление);
		
		Если ЭлементВыраженияУпорядочивания.Значение = НаправлениеСортировкиКомпоновкиДанных.Возр Тогда
			Сортировка = НСтр("ru = 'Возр'; en = 'Asc'");
		Иначе
			Сортировка = НСтр("ru = 'Убыв'; en = 'Desc'");
		КонецЕсли;
		ЧастиВыражения.Добавить(Сортировка);
		
		Если ЭлементВыраженияУпорядочивания.Пометка Тогда
			ЧастиВыражения.Добавить(НСтр("ru = 'Автоупорядочивание'; en = 'Auto-ordering'"));
		КонецЕсли;
		
		Представление = СтрСоединить(ЧастиВыражения, " ");
		ЧастиРезультата.Добавить(Представление);
		
	КонецЦикла;
	
	Возврат СтрСоединить(ЧастиРезультата, ", ");
	
КонецФункции

Функция ИмяПоляИтогаОбщийИтог() Экспорт
	
	Возврат "ОбщийИтог";
	
КонецФункции

Функция ПредставлениеМакета(Значение) Экспорт
	
	Вид = Значение.Вид;
	
	Если Вид = ИТКВ_Перечисления.СКДМакетПоля() Тогда
		
		Результат = Значение.Поле;
		
	ИначеЕсли Вид = ИТКВ_Перечисления.СКДМакетГруппировки()
				ИЛИ Вид = ИТКВ_Перечисления.СКДМакетЗаголовкаГруппировки() Тогда
				
		Результат = ПредставлениеМакетаГруппировки(Значение.ИмяГруппировки, Значение.ПоляГруппировки, Значение.ТипМакета);

	ИначеЕсли Вид = ИТКВ_Перечисления.СКДМакетРесурсов() Тогда
		
		Результат = ПредставлениеМакетаГруппировки(Значение.ИмяГруппировки1, Значение.ПоляГруппировки1, Значение.ТипМакета1);
		Результат = Результат + "; " + ПредставлениеМакетаГруппировки(Значение.ИмяГруппировки2, Значение.ПоляГруппировки2, Значение.ТипМакета2);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеМакетаГруппировки(ИмяГруппировки, ПоляГруппировки, ТипМакета)
	
	Если ЗначениеЗаполнено(ИмяГруппировки) Тогда
		Результат = ИмяГруппировки;
	Иначе
		Результат = СтрСоединить(ПоляГруппировки, ", ");
	КонецЕсли;
	
	Результат = Результат + " : " + ТипМакета;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
