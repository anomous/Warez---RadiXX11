@echo off
echo Cleaning...
cd .\Bin
del /q /s *.* 1>nul 2>nul
rd /s /q obj
rd /s /q Debug
rd /s /q Release
cd ..
echo Done.
