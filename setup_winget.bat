@echo off
set list=BraveSoftware.BraveBrowser;DebaucheeOpenSourceGroup.Barrier;BellSoft.LibericaJDK8Full;BellSoft.LibericaJDK8Full;Figma.Figma;GitHub.GitHubDesktop;Microsoft.VisualStudioCode;vim.vim;Obsidian.Obsidian;Notion.Notion;Google.Drive;Microsoft.Office;Valve.Steam;Git.Git; Intel.IntelDriverAndSupportAssistant;Nvidia.GeForceExperience;RARLab.WinRAR;9P9WDH947752
for %%a in (%list%) do ( 
 echo %%a
 echo/
 REM %%a 
 winget install -e --id %%a
 if %ERRORLEVEL% EQU 0 Echo %%a installed successfully.   %ERRORLEVEL%
)
