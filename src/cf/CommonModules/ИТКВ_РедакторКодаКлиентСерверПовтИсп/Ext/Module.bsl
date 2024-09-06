#Область ПрограммныйИнтерфейс

Функция СоответствиеИменКоллекцийИТипов() Экспорт
	
	Результат = Новый Соответствие;
	Результат.Вставить("справочники", "catalogs"); 
    Результат.Вставить("справочник", "catalogs");
	Результат.Вставить("catalogs", "catalogs");
	Результат.Вставить("документы", "documents");
    Результат.Вставить("документ", "documents");
	Результат.Вставить("documents", "documents");
	Результат.Вставить("регистрысведений", "infoRegs");
    Результат.Вставить("регистрсведений", "infoRegs");
	Результат.Вставить("informationregisters", "infoRegs");
	Результат.Вставить("регистрынакопления", "accumRegs");
    Результат.Вставить("регистрнакопления", "accumRegs");
	Результат.Вставить("accumulationregisters", "accumRegs");
	Результат.Вставить("регистрыбухгалтерии", "accountRegs");
    Результат.Вставить("регистрбухгалтерии", "accountRegs");
	Результат.Вставить("accountingregisters", "accountRegs");
	Результат.Вставить("обработки", "dataProc");
	Результат.Вставить("dataprocessors", "dataProc");
	Результат.Вставить("отчеты", "reports");
	Результат.Вставить("reports", "reports");
	Результат.Вставить("перечисления", "enums");
    Результат.Вставить("перечисление", "enums");
	Результат.Вставить("enums", "enums");
	Результат.Вставить("планысчетов", "сhartsOfAccounts");
    Результат.Вставить("плансчетов", "сhartsOfAccounts");
	Результат.Вставить("chartsofaccounts", "сhartsOfAccounts");
	Результат.Вставить("бизнеспроцессы", "businessProcesses");
    Результат.Вставить("бизнеспроцесс", "businessProcesses");
	Результат.Вставить("businessprocesses", "businessProcesses");
	Результат.Вставить("задачи", "tasks");
    Результат.Вставить("задача", "tasks");
	Результат.Вставить("tasks", "tasks");
	Результат.Вставить("планыобмена", "exchangePlans");
    Результат.Вставить("планобмена", "exchangePlans");
	Результат.Вставить("exchangeplans", "exchangePlans");
	Результат.Вставить("планывидовхарактеристик", "chartsOfCharacteristicTypes"); 
    Результат.Вставить("планывидовхарактеристик", "chartsOfCharacteristicTypes");
	Результат.Вставить("chartsofcharacteristictypes", "chartsOfCharacteristicTypes");
	Результат.Вставить("планывидоврасчета", "chartsOfCalculationTypes");
	Результат.Вставить("chartsofcalculationtypes", "chartsOfCalculationTypes");
	Результат.Вставить("ОбщиеМодули", "commonModules");
	
	Возврат Результат;
	
КонецФункции

Функция ИмяКоллекцииМетаданныхПоТипу(Тип) Экспорт
	
	Возврат СоответствиеИменКоллекцийИТипов().Получить(Тип);
	
КонецФункции

Функция СоответствиеИменКоллекцийИИмениКаталогаВыгрузки() Экспорт
	
	Результат = Новый Соответствие();
	Результат.Вставить("справочники"                 , "Catalogs");
	Результат.Вставить("catalogs"                    , "Catalogs");
	Результат.Вставить("документы"                   , "Documents");
	Результат.Вставить("documents"                   , "Documents");
	Результат.Вставить("регистрысведений"            , "InformationRegisters");
	Результат.Вставить("informationregisters"        , "InformationRegisters");
	Результат.Вставить("регистрынакопления"          , "AccumulationRegisters");
	Результат.Вставить("accumulationregisters"       , "AccumulationRegisters");
	Результат.Вставить("регистрыбухгалтерии"         , "AccountingRegisters");
	Результат.Вставить("accountingregisters"         , "AccountingRegisters");
	Результат.Вставить("регистрырасчета"             , "CalculationRegisters");
	Результат.Вставить("calculationregisters"        , "CalculationRegisters");
	Результат.Вставить("обработки"                   , "DataProcessors");
	Результат.Вставить("dataprocessors"              , "DataProcessors");
	Результат.Вставить("отчеты"                      , "Reports");
	Результат.Вставить("reports"                     , "Reports");
	Результат.Вставить("перечисления"                , "Enums");
	Результат.Вставить("enums"                       , "Enums");
	Результат.Вставить("планысчетов"                 , "ChartsOfAccounts");
	Результат.Вставить("chartsofaccounts"            , "ChartsOfAccounts");
	Результат.Вставить("бизнеспроцессы"              , "BusinessProcesses");
	Результат.Вставить("businessprocesses"           , "BusinessProcesses");
	Результат.Вставить("задачи"                      , "Tasks");
	Результат.Вставить("tasks"                       , "Tasks");
	Результат.Вставить("планыобмена"                 , "ExchangePlans");
	Результат.Вставить("exchangeplans"               , "ExchangePlans");
	Результат.Вставить("планывидовхарактеристик"     , "ChartsOfCharacteristicTypes");
	Результат.Вставить("chartsofcharacteristictypes" , "ChartsOfCharacteristicTypes");
	Результат.Вставить("планывидоврасчета"           , "ChartsOfCalculationTypes");
	Результат.Вставить("chartsofcalculationtypes"    , "ChartsOfCalculationTypes");
	Результат.Вставить("константы"                   , "Constants");
	Результат.Вставить("constants"                   , "Constants");
	Результат.Вставить("общиемодули"                 , "CommonModules");
	
	Возврат Результат;
	
КонецФункции

Функция ИмяКаталогаВыгрузкиПоТипу(Тип) Экспорт
	
	Возврат СоответствиеИменКоллекцийИИмениКаталогаВыгрузки().Получить(НРег(Тип));
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти

