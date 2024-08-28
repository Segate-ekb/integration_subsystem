@echo off
setlocal enabledelayedexpansion

REM Установка UTF-8 для консоли
chcp 65001 >nul

set "CHECK_MARK=✔️"
set "CROSS_MARK=❌"
set "INFO=ℹ️"
set "WARNING=⚠️"

REM Проверяем наличие oscript
where oscript >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo %CROSS_MARK% oscript не найден.
    set oscript_installed=0
) else (
    echo %CHECK_MARK% oscript найден.
    set oscript_installed=1
)

REM Проверяем наличие opm
where opm >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo %CROSS_MARK% opm не найден.
    set opm_installed=0
) else (
    echo %CHECK_MARK% opm найден.
    set opm_installed=1
)

set oscript_path=%localappdata%\ovm\current\bin

REM Если oscript не установлен, загружаем и устанавливаем ovm
if !oscript_installed! neq 1 (
    echo %INFO% Загружаем ovm...
    powershell -Command "Invoke-WebRequest -Uri https://github.com/oscript-library/ovm/releases/latest/download/ovm.exe -OutFile ovm.exe"

    if exist ovm.exe (
        echo %INFO% Устанавливаем oscript и opm через ovm...
        ovm.exe install stable
        if %ERRORLEVEL% neq 0 (
            echo %CROSS_MARK% Ошибка установки oscript и opm через ovm.
            exit /b 1
        )
        ovm.exe use stable

        REM Повторная проверка oscript после установки
        if not exist "%oscript_path%\oscript.exe" (
            echo %CROSS_MARK% oscript все еще не найден.
            exit /b 1
        ) else (
            echo %CHECK_MARK% oscript установлен успешно.
        )

        REM Повторная проверка opm после установки
        if not exist "%oscript_path%\opm.bat" (
            echo %CROSS_MARK% opm все еще не найден.
            exit /b 1
        ) else (
            echo %CHECK_MARK% opm установлен успешно.
        )
    ) else (
        echo %CROSS_MARK% Не удалось загрузить ovm.
        exit /b 1
    )
)

REM Устанавливаем пакеты
echo %INFO% Устанавливаем пакеты precommit4onec и vanessa-runner...
call "%oscript_path%\opm.bat" install precommit4onec vanessa-runner > install_log.txt 2>&1
if %ERRORLEVEL% neq 0 (
    echo %CROSS_MARK% Ошибка установки пакетов.
    type install_log.txt
    exit /b 1
)
del install_log.txt
echo %CHECK_MARK% Пакеты установлены успешно.

REM Проверяем, установился ли precommit4onec
if not exist "%oscript_path%\precommit4onec.bat" (
    echo %CROSS_MARK% precommit4onec не установлен.
    exit /b 1
) else (
    echo %CHECK_MARK% precommit4onec установлен успешно.
)

REM Установка precommit hook
echo %INFO% Устанавливаем precommit hook...
call "%oscript_path%\precommit4onec.bat" install . > precommit_log.txt 2>&1
if %ERRORLEVEL% neq 0 (
    echo %CROSS_MARK% Ошибка установки precommit hook.
    type precommit_log.txt
    exit /b 1
)
del precommit_log.txt
echo %CHECK_MARK% precommit hook установлен успешно.

REM Проверяем, установился ли vanessa-runner
if not exist "%oscript_path%\vrunner.bat" (
    echo %CROSS_MARK% vrunner не установлен.
    exit /b 1
) else (
    echo %CHECK_MARK% vrunner установлен успешно.
)

REM Вопрос пользователю о настройке файла окружения
:ask_again
set "response="
set /p response="%INFO% Хотите настроить файл окружения? (y/n): "

if /i "%response%"=="y" (
    echo %INFO% Настраиваем файл окружения...

    REM Переименовываем env.json.example в env.json
    if exist env.json.example (
        ren env.json.example env.json
        echo %CHECK_MARK% Файл env.json настроен.
    ) else (
        echo %CROSS_MARK% Файл env.json.example не найден.
        exit /b 1
    )

    REM Запускаем oscript tools/init_project.os
    if exist "%oscript_path%\oscript.exe" (
        "%oscript_path%\oscript.exe" tools/init_project.os
        if %ERRORLEVEL% neq 0 (
            echo %CROSS_MARK% Ошибка выполнения oscript tools/init_project.os.
            exit /b 1
        )
        echo %CHECK_MARK% Проект успешно инициализирован.
    ) else (
        echo %CROSS_MARK% oscript не найден.
        exit /b 1
    )

) else if /i "%response%"=="n" (
    echo %INFO% Настройка файла окружения пропущена.
) else (
    echo %WARNING% Некорректный ввод. Пожалуйста, введите 'y' или 'n'.
    goto ask_again
)

echo %CHECK_MARK% Настройка тестового окружения завершена успешно.
exit /b 0
