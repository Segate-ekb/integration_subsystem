// Copyright Copyright 2023-2024 Andrei Chernyak
// Licensed under the Apache License, Version 2.0
//

Функция ШаблонURLGet(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки["Content-Type"] = "text/plain; version=0.0.4; charset=utf-8";
	Ответ.УстановитьТелоИзСтроки(пэ_Метрики.ТелоСообщения(), "UTF8");
	Возврат Ответ;
	
КонецФункции
