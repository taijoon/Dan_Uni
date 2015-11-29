@echo off

:: Expected command line:	$(OutDir) $(Platform) $(Configuration)

set CFG=%2\%3
if [%3] == [] set CFG=Win32\Release

set BINPATH=%~1
if [%BINPATH%] == [] set BINPATH=windows\%CFG%
set TOPDIR=%~dp0..

pushd %TOPDIR%

echo Generating custom blinding
"%BINPATH%\CustomTool.exe" b edp_custom_blinding 1> source\custom_blind.c
popd
