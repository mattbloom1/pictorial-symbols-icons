@echo off
rem Pulls the latest brand tokens from the Brand repo into this site and pushes them,
rem so GitHub Pages republishes with the new look.
setlocal
cd /d "%~dp0.."

echo == Getting the latest site code ==
git pull
if errorlevel 1 goto :fail

echo.
echo == Downloading the latest brand tokens ==
set "SRC=%TEMP%\brand-src-%RANDOM%"
git clone --depth 1 https://github.com/mattbloom1/Brand "%SRC%"
if errorlevel 1 goto :fail
copy /y "%SRC%\system\generated\tokens.css" "brand\tokens.css" >nul
if errorlevel 1 goto :fail
rmdir /s /q "%SRC%"

echo.
echo == Saving ==
git add brand\tokens.css
git diff --cached --quiet
if not errorlevel 1 (
  echo Brand was already up to date.
  exit /b 0
)
git commit -m "Update brand tokens"
if errorlevel 1 goto :fail
git push
if errorlevel 1 goto :fail

echo.
echo DONE: pushed. GitHub Pages republishes in about a minute.
exit /b 0

:fail
echo.
echo STOPPED: something failed, see the message above.
exit /b 1
