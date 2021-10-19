@echo off  
REM Brave  
winget install -e --id BraveSoftware.BraveBrowser  
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Barrier
winget install -e --id DebaucheeOpenSourceGroup.Barrier  
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Jdk8
winget install -e --id BellSoft.LibericaJDK8Full
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM IntellijIdea
winget install -e --id JetBrains.IntelliJIDEA.Community  
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Figma
winget install -e --id Figma.Figma
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Github Desktop
winget install -e --id GitHub.GitHubDesktop
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Vs Code
winget install -e --id Microsoft.VisualStudioCode
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM vim
winget install -e --id vim.vim
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Obsidian
winget install -e --id Obsidian.Obsidian
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Notion
winget install -e --id Notion.Notion
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Google Drive
winget install -e --id Google.Drive
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Office 365
winget install -e --id Microsoft.Office
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Steam
winget install -e --id Valve.Steam
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Git
winget install -e --id Git.Git
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Intel Driver and Support Assistant
winget install -e --id Intel.IntelDriverAndSupportAssistant
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Nvidia GeForce Experience
winget install -e --id Nvidia.GeForceExperience
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
REM Winrar
winget install -e --id RARLab.WinRAR
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%

REM Msi proprietary apps and drivers
REM MSI Driver & App Center
winget install -e --id 9P9WDH947752
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%

