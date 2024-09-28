﻿&Вместо("ЗарегистрироватьСообщениеКУдалению")
Процедура Мок_ЗарегистрироватьСообщениеКУдалению(ИдентификаторСообщения, НаправлениеПотока)
  ПараметрыМетода = Мокито.МассивПараметров(ИдентификаторСообщения, НаправлениеПотока);
  ПрерватьВыполнение = Ложь;

  МокитоПерехват.АнализВызова(РегистрыСведений.инт_СообщенияКУдалению, "ЗарегистрироватьСообщениеКУдалению", ПараметрыМетода, ПрерватьВыполнение);

  Если Не ПрерватьВыполнение Тогда
    ПродолжитьВызов(ИдентификаторСообщения, НаправлениеПотока);
  КонецЕсли;
КонецПроцедуры
