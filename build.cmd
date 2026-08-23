@chcp 65001

@rem артефакт со столкновением идентификаторов объектов метаданных не собирается
call "%~dp0check-ids.cmd"
@if errorlevel 1 exit /b 1

@rem формирование файла конфигурации. для включения раскомментируйте код ниже
call vrunner compile --src src/cf --out build/1cv8.cf %*

@rem обновление конфигурации основной разработческой ИБ из хранилища. для включения раскомментируйте код ниже
@rem call vrunner loadrepo %*
@rem call vrunner updatedb %*

@rem собрать внешние обработчики и отчеты в каталоге build
@rem call vrunner compileepf src/epf/МояВнешняяОбработка build %*
@rem call vrunner compileepf src/erf/МойВнешнийОтчет build %*

@rem собрать расширения конфигурации внутри ИБ
@rem call vrunner compileext src/cfe/МоеРасширение МоеРасширение %*
