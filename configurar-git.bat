@echo off
:: ==============================================================================
:: ATALHO PARA EXECUÇÃO DO CONFIGURADOR GIT
:: ==============================================================================
:: Este arquivo permite que o aluno execute o script do PowerShell dando um 
:: duplo clique, sem precisar abrir o terminal ou digitar comandos.
:: ==============================================================================

:: Define o título do terminal CMD
title Inicializando Configurador Git...

:: Altera a página de código do console para UTF-8 (corrige acentuação e bordas)
chcp 65001 > nul

:: Executa o PowerShell burlando a política de restrição de scripts temporariamente
:: %~dp0 garante que ele busque o script .ps1 na mesma pasta deste arquivo .bat
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0configurar-git.ps1"

:: Impede que o prompt feche imediatamente se houver alguma falha na inicialização
if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERRO] Ocorreu uma falha ao iniciar o script de configuracao.
    echo Verifique se o arquivo configurar-git.ps1 esta na mesma pasta.
    echo.
    pause
)
