﻿#Область ПрограммныйИнтерфейс

Функция ЗагрузитьВсе(ВидИнструмента = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить(ИТКВ_НастройкиКлиентСервер.ИмяРеквизитаНастройкиОбщие(), ИТКВ_Настройки.Загрузить());
	
	Если ЗначениеЗаполнено(ВидИнструмента) Тогда
		
		Результат.Вставить(ИТКВ_НастройкиКлиентСервер.ИмяРеквизитаНастройки(), ИТКВ_Настройки.Загрузить(ВидИнструмента));
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
