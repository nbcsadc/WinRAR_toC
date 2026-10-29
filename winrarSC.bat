@echo off
setlocal enabledelayedexpansion

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 错误：请右键选择“以管理员身份运行”此脚本。
    pause
    exit /b 1
)

set "INSTALLER="
set "TEMP_DIR=C:\WinRAR_Temp"

echo ============================================
echo   WinRAR 安装脚本
echo ============================================
echo   1. 使用本地已有的安装包
echo   2. 输入链接下载安装包
echo ============================================
set /p CHOICE=请选择 [1/2]:

if "%CHOICE%"=="1" goto LOCAL_FILE
if "%CHOICE%"=="2" goto DOWNLOAD_FILE
echo 无效选择，退出。
pause
exit /b 1

:LOCAL_FILE
echo.
set /p INSTALLER=请输入安装包的完整路径（例如 D:\Downloads\winrar-x64-711sc.exe）:
if not exist "!INSTALLER!" (
    echo 错误：文件不存在：!INSTALLER!
    pause
    exit /b 1
)
goto INSTALL

:DOWNLOAD_FILE
echo.
set /p DL_URL=请粘贴下载链接:
if "!DL_URL!"=="" (
    echo 错误：链接不能为空。
    pause
    exit /b 1
)

if not exist "%TEMP_DIR%" md "%TEMP_DIR%"
set "INSTALLER=%TEMP_DIR%\winrar-setup.exe"

echo 开始下载...
powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '!DL_URL!' -OutFile '%INSTALLER%' -Headers @{'Referer'='https://www.chiphell.com/'; 'User-Agent'='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'}"

if not exist "%INSTALLER%" (
    echo 下载失败，请检查链接或网络。
    pause
    exit /b 1
)
goto INSTALL

:INSTALL
echo.
echo 开始静默安装...
start /wait "" "!INSTALLER!" /S

echo 写入注册文件...
(
echo RAR registration data
echo State Grid Corporation Of China
echo 50000 PC usage license
echo UID=5827a0bd1c43525d0a5d
echo 64122122500a5d3d56f784f3a440ac3fb632d34e08bbaa37fc7712
echo 6acaeb8eb044810272e86042cb7c79b1da0eaf88c79f8a7c6dd77b
echo dba335e27a109997ac90fb0e10e4129e79f46c42b4ee1832fa5113
echo 7443fcc1124840d4dd36f3af84a5c915a760b18c6394f938168227
echo fbf29edbc4b34ef85ee53fbfca71814a82afadf073876b4b033451
echo b6292a7cc7975b3ff3cc73404abbf7c126787344169eeae4609f62
echo c9ffbc159bf2640ad5d9b88f8fa9d9cbf2b7e5b022a21938465244
) > "C:\Program Files\WinRAR\rarreg.key"

if exist "%TEMP_DIR%\winrar-setup.exe" (
    echo 清理临时文件...
    del /q "%TEMP_DIR%\winrar-setup.exe" 2>nul
    rd "%TEMP_DIR%" 2>nul
)

echo.
echo 安装与注册已完成。
pause