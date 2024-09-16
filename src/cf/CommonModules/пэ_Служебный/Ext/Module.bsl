// Экспортер метрик из базы данных системы 1С:Предприятие 8 в Prometheus
//
// Copyright 2023-2024 Andrei Chernyak
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
// URL: https://github.com/ChernyakAI/1c_prometheus_exporter
//

#Область ПрограммныйИнтерфейс

// Отправить метрики в prometheus pushgateway регламентным заданием
//
Процедура пэ_ОтправкаДанныхВШлюзPrometheus() Экспорт
	
	пэ_Метрики.ВыполнитьОтправкуМетрик();
	
КонецПроцедуры

// Возвращает регламентное задание базы, если оно было создано ранее
//
// Возвращаемое значение:
//  - Регламентное задание - найденное задание экспорта данных
//  - Неопределено - если задание в системе ранее не создавалось
//
Функция РегламентноеЗаданиеЭкспорта() Экспорт
	

КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ЭкранироватьСимволы(Знач СтрокаСимволов = "") Экспорт
	
	СтрокаСимволов = СтрЗаменить(СтрокаСимволов, """", "\""");
	Возврат СтрокаСимволов;
	
КонецФункции

#КонецОбласти
