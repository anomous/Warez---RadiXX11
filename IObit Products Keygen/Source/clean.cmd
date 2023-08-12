@echo off
echo Cleaning...
cd ..\Bin
del /q /s *.* 1>nul 2>nul
cd ..\Source\Forms
del /q /s *.~* *.res *.dcu *.ddp *.log *.bak *.tmp 1>nul 2>nul
cd ..\Resources
del /q /s *.~* *.res *.dcu *.ddp *.log *.bak *.tmp 1>nul 2>nul
cd ..\Units
del /q /s *.~* *.res *.dcu *.ddp *.log *.bak *.tmp 1>nul 2>nul
cd ..
echo Done.