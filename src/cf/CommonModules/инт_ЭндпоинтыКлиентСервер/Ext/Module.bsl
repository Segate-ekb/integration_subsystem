﻿////////////////////////////////////////////////////////////////////////////////
// инт_ЭндпоинтыКлиентСервер
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс
Функция СформироватьЗаголовок(Знач АдресРесурса) Экспорт
Заголовок = "<Задайте параметры подключения>";

Если ЗначениеЗаполнено(АдресРесурса) Тогда

	Если СтрДлина(АдресРесурса) > 30 Тогда
		Заголовок = СтрШаблон("%1...%2",Лев(АдресРесурса, 22), Сред(АдресРесурса, СтрДлина(АдресРесурса)-5));
	Иначе
		Заголовок = АдресРесурса;
	КонецЕсли;
КонецЕсли;

Возврат Заголовок;
КонецФункции

Функция ИмяГруппыЭндпоинт() Экспорт
	Возврат "ГруппаЭндпоинт";
КонецФункции

Функция ИмяГруппыСтраниц() Экспорт
	Возврат "СтраницыАвторизация";
КонецФункции

Функция ИмяАдресРесурса() Экспорт
	Возврат "АдресРесурса";
КонецФункции

Функция ИмяТипАвторизации() Экспорт
	Возврат "ТипАвторизации";
КонецФункции

#КонецОбласти
