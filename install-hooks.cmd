@chcp 65001 > nul
@setlocal

@rem подключение проверки уникальности идентификаторов к фиксации изменений
@pushd "%~dp0"

@set "HOOKS="
@for /f "delims=" %%i in ('git rev-parse --git-common-dir') do @set "HOOKS=%%i\hooks"
@if not defined HOOKS goto :no_repo
@set "HOOKS=%HOOKS:/=\%"

@if not exist "%HOOKS%\pre-commit" goto :install
@findstr /c:"check-ids" "%HOOKS%\pre-commit" > nul && goto :install
@echo Ловушка "%HOOKS%\pre-commit" занята другим средством.
@echo Добавьте в неё вызов check-ids.cmd вручную.
@popd
@exit /b 1

:install
@copy /y "tools\hooks\pre-commit" "%HOOKS%\pre-commit" > nul
@echo Проверка уникальности идентификаторов подключена к фиксации изменений: "%HOOKS%\pre-commit"
@popd
@exit /b 0

:no_repo
@echo Каталог не является репозиторием Git: ловушку устанавливать некуда.
@popd
@exit /b 1
