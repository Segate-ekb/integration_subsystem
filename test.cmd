@chcp 65001
@setlocal enableextensions

set "PROJECT_PATH=%~dp0"
if "%PROJECT_PATH:~-1%"=="\" set "PROJECT_PATH=%PROJECT_PATH:~0,-1%"

set "REPORT_DIR=%PROJECT_PATH%\build\test-reports"
set "CONFIG_PATH=%PROJECT_PATH%\build\yaxunit-config.json"
set "EXIT_CODE_PATH=%REPORT_DIR%\exitCode.txt"

@rem Очистить предыдущие отчёты
if exist "%REPORT_DIR%" rd /s /q "%REPORT_DIR%"
mkdir "%REPORT_DIR%" 2>nul

@rem Генерация конфигурации YAXUnit с абсолютными путями
> "%CONFIG_PATH%" (
echo {
echo   "reportPath": "%REPORT_DIR:\=\\%",
echo   "closeAfterTests": true,
echo   "filter": { "extensions": ["YAXUNIT"] },
echo   "settings": { "ВТранзакции": false },
echo   "reportFormat": "allure",
echo   "showReport": false,
echo   "logging": {
echo     "file": "",
echo     "console": true,
echo     "enable": true,
echo     "level": "info"
echo   },
echo   "exitCode": "%EXIT_CODE_PATH:\=\\%",
echo   "projectPath": "%PROJECT_PATH:\=\\%",
echo   "ПодключатьВнешниеКомпоненты": true
echo }
)

echo ==============================
echo   YAXUnit Test Runner
echo ==============================
echo Project: %PROJECT_PATH%
echo Reports: %REPORT_DIR%
echo.

@rem Запуск YAXUnit тестов через vrunner
call vrunner run --command "RunUnitTests=%CONFIG_PATH%" %*
set VRUNNER_EXIT=%ERRORLEVEL%

@rem Чтение кода возврата YAXUnit
if exist "%EXIT_CODE_PATH%" (
    set /p YAXUNIT_EXIT=<"%EXIT_CODE_PATH%"
) else (
    echo [WARN] Exit code file not found
    set YAXUNIT_EXIT=%VRUNNER_EXIT%
)

@rem Вывод результатов
echo.
echo ==============================
echo   Test execution finished
echo   Exit code: %YAXUNIT_EXIT%
echo ==============================
if exist "%REPORT_DIR%\*.xml" (
    echo   Reports:
    dir /b "%REPORT_DIR%\*.xml" 2>nul
)
echo ==============================

exit /b %YAXUNIT_EXIT%
