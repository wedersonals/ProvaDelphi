@ECHO off

SET BASEDIR=%~dp0
SET EXECDIR=%BASEDIR%Aplicativo
SET APPNAME=ProvaDelphiApp

cd %EXECDIR%

CodeCoverage -e "%EXECDIR%\Bin\%APPNAME%.exe" -m "%EXECDIR%\Bin\%APPNAME%.map" -uf dcov_units.lst -spf dcov_paths.lst -od "%EXECDIR%\Bin\CodeCoverageOutput\" -lt -html

cd %BASEDIR%