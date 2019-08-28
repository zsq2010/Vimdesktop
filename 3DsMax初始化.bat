@echo off
echo 如果你的3dsmax20**是安装在默认目录（C:\Program Files\Autodesk\3ds Max 20**）
echo 那么直接回车即可。
echo 否则请自行拷贝。
echo.
pause

echo.
if exist "C:\Program Files\Autodesk\3ds Max 2014\3dsmax.exe" xcopy /y /e "%~dp0\custom\maxScripts\Startup\*" "C:\Program Files\Autodesk\3ds Max 2014\scripts\Startup"
if exist "C:\Program Files\Autodesk\3ds Max 2015\3dsmax.exe" xcopy /y /e "%~dp0\custom\maxScripts\Startup\*" "C:\Program Files\Autodesk\3ds Max 2015\scripts\Startup"
if exist "C:\Program Files\Autodesk\3ds Max 2016\3dsmax.exe" xcopy /y /e "%~dp0\custom\maxScripts\Startup\*" "C:\Program Files\Autodesk\3ds Max 2016\scripts\Startup"
if exist "C:\Program Files\Autodesk\3ds Max 2017\3dsmax.exe" xcopy /y /e "%~dp0\custom\maxScripts\Startup\*" "C:\Program Files\Autodesk\3ds Max 2017\scripts\Startup"
if exist "C:\Program Files\Autodesk\3ds Max 2018\3dsmax.exe" xcopy /y /e "%~dp0\custom\maxScripts\Startup\*" "C:\Program Files\Autodesk\3ds Max 2018\scripts\Startup"
if exist "C:\Program Files\Autodesk\3ds Max 2019\3dsmax.exe" xcopy /y /e "%~dp0\custom\maxScripts\Startup\*" "C:\Program Files\Autodesk\3ds Max 2019\scripts\Startup"
if exist "C:\Program Files\Autodesk\3ds Max 2020\3dsmax.exe" xcopy /y /e "%~dp0\custom\maxScripts\Startup\*" "C:\Program Files\Autodesk\3ds Max 2020\scripts\Startup"

if not exist "C:\Program Files\Autodesk\3ds Max 2014\3dsmax.exe" echo 没找到 C:\Program Files\Autodesk\3ds Max 2014 目录
if not exist "C:\Program Files\Autodesk\3ds Max 2015\3dsmax.exe" echo 没找到 C:\Program Files\Autodesk\3ds Max 2015 目录
if not exist "C:\Program Files\Autodesk\3ds Max 2016\3dsmax.exe" echo 没找到 C:\Program Files\Autodesk\3ds Max 2016 目录
if not exist "C:\Program Files\Autodesk\3ds Max 2017\3dsmax.exe" echo 没找到 C:\Program Files\Autodesk\3ds Max 2017 目录
if not exist "C:\Program Files\Autodesk\3ds Max 2018\3dsmax.exe" echo 没找到 C:\Program Files\Autodesk\3ds Max 2018 目录
if not exist "C:\Program Files\Autodesk\3ds Max 2019\3dsmax.exe" echo 没找到 C:\Program Files\Autodesk\3ds Max 2019 目录
if not exist "C:\Program Files\Autodesk\3ds Max 2020\3dsmax.exe" echo 没找到 C:\Program Files\Autodesk\3ds Max 2020 目录
echo.

pause