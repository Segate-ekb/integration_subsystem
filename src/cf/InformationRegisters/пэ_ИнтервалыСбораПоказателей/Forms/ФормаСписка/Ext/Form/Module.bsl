﻿// Copyright Copyright 2023-2024 Andrei Chernyak
// Licensed under the Apache License, Version 2.0
//

#Область ОбработчикиКомандФормы

&НаСервереБезКонтекста
Процедура ЗаполнитьПоУмолчаниюНаСервере()
	
	НЗ = РегистрыСведений.пэ_ИнтервалыСбораПоказателей.СоздатьНаборЗаписей();
	НЗ.Записать();
	
	НЗ.Загрузить(РегистрыСведений.пэ_ИнтервалыСбораПоказателей.СтандартныеИнтервалы());
	НЗ.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	
	ЗаполнитьПоУмолчаниюНаСервере();
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
