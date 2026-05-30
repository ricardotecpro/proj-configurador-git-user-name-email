# ==============================================================================
# SCRIPT DE CONFIGURAÇÃO DO GIT & GITHUB PARA LABORATÓRIO DE INFORMÁTICA
# ==============================================================================
# Desenvolvido para facilitar a configuração inicial do Git por estudantes
# e garantir a segurança das credenciais em computadores compartilhados.
#
# Idioma: Português (Brasil)
# Compatibilidade: PowerShell 5.1+ (Windows 10/11)
# ==============================================================================

# Garante codificação UTF-8 para exibir os caracteres especiais e bordas corretamente
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Configura o título da janela
$Host.UI.RawUI.WindowTitle = "Configurador Git - Lab de Informática"

# --- CONFIGURAÇÃO DE CORES ---
$ColorHeader = "Cyan"
$ColorAccent = "DarkCyan"
$ColorSuccess = "Green"
$ColorWarning = "Yellow"
$ColorError = "Red"
$ColorText = "White"
$ColorMuted = "Gray"

# --- FUNÇÕES DE INTERFACE TUI ---

function Clear-Console {
    Clear-Host
}

function Write-Border {
    Write-Host "===============================================================================" -ForegroundColor $ColorAccent
}

function Write-Header {
    Clear-Console
    Write-Host "┌─────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor $ColorHeader
    Write-Host "│               CONFIGURAÇÃO DO GIT & GITHUB - LAB DE INFORMÁTICA            │" -ForegroundColor $ColorHeader
    Write-Host "└─────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor $ColorHeader
    Write-Host ""
}

function Write-Footer {
    Write-Host ""
    Write-Border
    Write-Host " Dica: Sempre limpe suas credenciais antes de sair da máquina (Opção 5)." -ForegroundColor $ColorWarning
    Write-Host "===============================================================================" -ForegroundColor $ColorAccent
}

function Press-AnyKey {
    Write-Host "`nPressione qualquer tecla para voltar ao menu..." -ForegroundColor $ColorMuted
    $null = [Console]::ReadKey($true)
}

# --- FUNÇÕES DE VERIFICAÇÃO ---

function Check-GitInstalled {
    $gitPath = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitPath) {
        Write-Host " [ERRO] O Git não está instalado nesta máquina!" -ForegroundColor $ColorError
        Write-Host " Por favor, avise o professor ou o administrador do laboratório." -ForegroundColor $ColorWarning
        Write-Host ""
        Write-Host " Para instalar o Git, baixe em: https://git-scm.com/download/win" -ForegroundColor $ColorHeader
        Write-Host ""
        return $false
    }
    return $true
}

function Get-GitConfig {
    $config = @{
        Name = $null
        Email = $null
        Branch = $null
        Helper = $null
    }
    
    # Executa comandos silenciando erros caso não existam configurações definidas
    $config.Name = & { git config --global user.name } 2>$null
    $config.Email = & { git config --global user.email } 2>$null
    $config.Branch = & { git config --global init.defaultBranch } 2>$null
    $config.Helper = & { git config --global credential.helper } 2>$null
    
    return $config
}

function Show-CurrentConfigPanel {
    $cfg = Get-GitConfig
    
    Write-Host "┌── Configurações Atuais do Git ──────────────────────────────────────────────" -ForegroundColor $ColorHeader
    
    Write-Host "  Nome de Usuário (user.name)  : " -NoNewline -ForegroundColor $ColorText
    if ($cfg.Name) {
        Write-Host "$($cfg.Name)" -ForegroundColor $ColorSuccess
    } else {
        Write-Host "[Não configurado]" -ForegroundColor $ColorError
    }

    Write-Host "  E-mail de Cadastro (user.email): " -NoNewline -ForegroundColor $ColorText
    if ($cfg.Email) {
        Write-Host "$($cfg.Email)" -ForegroundColor $ColorSuccess
    } else {
        Write-Host "[Não configurado]" -ForegroundColor $ColorError
    }

    Write-Host "  Branch Padrão (defaultBranch)  : " -NoNewline -ForegroundColor $ColorText
    if ($cfg.Branch) {
        Write-Host "$($cfg.Branch)" -ForegroundColor $ColorSuccess
    } else {
        Write-Host "[Não configurado (Padrão: master)]" -ForegroundColor $ColorMuted
    }

    Write-Host "  Gerenciador de Senhas (helper) : " -NoNewline -ForegroundColor $ColorText
    if ($cfg.Helper) {
        Write-Host "$($cfg.Helper)" -ForegroundColor $ColorSuccess
    } else {
        Write-Host "[Nenhum - Terá que digitar a senha sempre]" -ForegroundColor $ColorWarning
    }
    
    Write-Host "└─────────────────────────────────────────────────────────────────────────────" -ForegroundColor $ColorHeader
    Write-Host ""
}

# --- FLUXOS DO MENU ---

# Opção 1: Configurar Nome e E-mail
function Option-ConfigureGit {
    Write-Header
    Write-Host "   === OPÇÃO 1: CONFIGURAÇÃO DE NOME E E-MAIL ===" -ForegroundColor $ColorHeader
    Write-Host ""
    
    Show-CurrentConfigPanel

    Write-Host " Instruções:" -ForegroundColor $ColorMuted
    Write-Host "  - Nome de Usuário: Use seu nome real (ex: 'João Silva'), não o username do GitHub." -ForegroundColor $ColorMuted
    Write-Host "  - E-mail do GitHub: Use o mesmo e-mail cadastrado na sua conta do GitHub para" -ForegroundColor $ColorMuted
    Write-Host "    vincular seus commits ao seu perfil." -ForegroundColor $ColorMuted
    Write-Host ""

    # Captura e valida o Nome
    $nome = ""
    while ($true) {
        Write-Host " Digite seu Nome Completo (Nome e Sobrenome):" -ForegroundColor $ColorText
        Write-Host " >> " -NoNewline -ForegroundColor $ColorHeader
        $nome = (Read-Host).Trim()
        
        if ($nome -eq "") {
            Write-Host "  [!] O nome não pode ser vazio.`n" -ForegroundColor $ColorError
            continue
        }
        if ($nome.Split(" ").Count -lt 2) {
            Write-Host "  [Aviso] É altamente recomendável digitar Nome e Sobrenome para evitar conflitos." -ForegroundColor $ColorWarning
            Write-Host "  Deseja continuar assim mesmo? [S/N]: " -NoNewline -ForegroundColor $ColorWarning
            $confNome = Read-Host
            if ($confNome -notmatch "^[SsPpYy]") {
                Write-Host ""
                continue
            }
        }
        break
    }

    Write-Host ""

    # Captura e valida o E-mail
    $email = ""
    while ($true) {
        Write-Host " Digite seu E-mail do GitHub:" -ForegroundColor $ColorText
        Write-Host " >> " -NoNewline -ForegroundColor $ColorHeader
        $email = (Read-Host).Trim()

        if ($email -eq "") {
            Write-Host "  [!] O e-mail não pode ser vazio.`n" -ForegroundColor $ColorError
            continue
        }
        if ($email -notmatch "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$") {
            Write-Host "  [!] Formato de e-mail inválido. Por favor, tente novamente.`n" -ForegroundColor $ColorError
            continue
        }
        break
    }

    # Confirmação Final dos dados digitados
    Write-Header
    Write-Host "   === CONFIRMAÇÃO DOS DADOS DIRETOS ===" -ForegroundColor $ColorHeader
    Write-Host ""
    Write-Host "  Você digitou os seguintes dados:" -ForegroundColor $ColorText
    Write-Host ""
    Write-Host "  Nome Completo: " -NoNewline -ForegroundColor $ColorMuted
    Write-Host "$nome" -ForegroundColor $ColorSuccess
    Write-Host "  E-mail Git:    " -NoNewline -ForegroundColor $ColorMuted
    Write-Host "$email" -ForegroundColor $ColorSuccess
    Write-Host ""
    Write-Host "  Esses dados serão aplicados globalmente nesta máquina." -ForegroundColor $ColorMuted
    Write-Host ""
    Write-Host " Deseja salvar estas configurações? [S/n]: " -NoNewline -ForegroundColor $ColorWarning
    
    $confirm = Read-Host
    if ($confirm -eq "" -or $confirm -match "^[SsPpYy]") {
        Write-Host "`n Salvando configurações..." -ForegroundColor $ColorHeader
        
        try {
            # Define as configurações básicas exigidas
            git config --global user.name "$nome"
            git config --global user.email "$email"
            
            # Define 'main' como branch padrão ao criar repositórios novos (padrão GitHub)
            git config --global init.defaultBranch main
            
            # Ativa o gerenciador de credenciais do Windows para facilitar o login por HTTPS
            git config --global credential.helper manager
            
            Write-Host " [OK] Configurações aplicadas com sucesso!" -ForegroundColor $ColorSuccess
            Write-Host " [OK] Nome de usuário associado globalmente." -ForegroundColor $ColorSuccess
            Write-Host " [OK] E-mail de commits associado globalmente." -ForegroundColor $ColorSuccess
            Write-Host " [OK] Branch padrão configurada como 'main'." -ForegroundColor $ColorSuccess
            Write-Host " [OK] Armazenamento de senhas via Credential Manager ativado." -ForegroundColor $ColorSuccess
        }
        catch {
            Write-Host " [ERRO] Falha ao executar comandos do Git: $_" -ForegroundColor $ColorError
        }
    } else {
        Write-Host "`n Configuração cancelada. Nenhuma alteração foi feita." -ForegroundColor $ColorWarning
    }

    Press-AnyKey
}

# Opção 2: Verificar Configurações Detalhadas
function Option-VerifyConfig {
    Write-Header
    Write-Host "   === OPÇÃO 2: DETALHES DA CONFIGURAÇÃO DO GIT ===" -ForegroundColor $ColorHeader
    Write-Host ""

    Show-CurrentConfigPanel

    Write-Host " Lista completa de configurações globais ativas:" -ForegroundColor $ColorHeader
    Write-Host "-------------------------------------------------------------------------------" -ForegroundColor $ColorMuted
    
    $allConfig = & { git config --global --list } 2>$null
    if ($allConfig) {
        $allConfig | ForEach-Object {
            Write-Host "  $_" -ForegroundColor $ColorText
        }
    } else {
        Write-Host "  Nenhuma outra configuração global encontrada." -ForegroundColor $ColorMuted
    }
    
    Write-Host "-------------------------------------------------------------------------------" -ForegroundColor $ColorMuted
    
    Press-AnyKey
}

# Opção 3: Como conectar e autenticar no GitHub
function Option-GitHubAuth {
    Write-Header
    Write-Host "   === OPÇÃO 3: AUTENTICAÇÃO COM O GITHUB ===" -ForegroundColor $ColorHeader
    Write-Host ""
    
    Write-Host " Como funciona o login no laboratório usando HTTPS (Recomendado):" -ForegroundColor $ColorHeader
    Write-Host ""
    Write-Host " 1. Quando você clonar um repositório privado ou tentar fazer 'push'," -ForegroundColor $ColorText
    Write-Host "    o Git abrirá uma pequena janela de diálogo do Windows." -ForegroundColor $ColorText
    Write-Host " 2. Clique no botão de login com o navegador (" -NoNewline -ForegroundColor $ColorText
    Write-Host "Sign in with your browser" -ForegroundColor $ColorSuccess
    Write-Host ")." -ForegroundColor $ColorText
    Write-Host " 3. Faça o login na sua conta do GitHub na janela do navegador que se abriu." -ForegroundColor $ColorText
    Write-Host " 4. Autorize o aplicativo 'Git Credential Manager'." -ForegroundColor $ColorText
    Write-Host " 5. Pronto! O Git salvará o token de forma segura e você não precisará digitar" -ForegroundColor $ColorText
    Write-Host "    sua senha no console." -ForegroundColor $ColorText
    Write-Host ""
    Write-Host " IMPORTANTE:" -ForegroundColor $ColorWarning
    Write-Host " Como a máquina é compartilhada, utilize a " -NoNewline -ForegroundColor $ColorText
    Write-Host "OPÇÃO 5" -ForegroundColor $ColorWarning
    Write-Host " deste script para desconectar" -ForegroundColor $ColorText
    Write-Host " e apagar seus dados de login ANTES de desligar ou sair da máquina!" -ForegroundColor $ColorText
    
    Press-AnyKey
}

# Opção 4: Guia de Comandos Básicos (Cola / Cheat Sheet)
function Option-CheatSheet {
    Write-Header
    Write-Host "   === OPÇÃO 4: COLA DE COMANDOS BÁSICOS DO GIT ===" -ForegroundColor $ColorHeader
    Write-Host ""
    
    Write-Host " ┌── Para Iniciar um Novo Projeto ──────────────────────────────────────────" -ForegroundColor $ColorHeader
    Write-Host "   git init                    " -NoNewline -ForegroundColor $ColorSuccess
    Write-Host "- Inicializa um novo repositório Git local" -ForegroundColor $ColorText
    Write-Host "   git clone <URL-do-Repo>     " -NoNewline -ForegroundColor $ColorSuccess
    Write-Host "- Baixa um repositório existente do GitHub" -ForegroundColor $ColorText
    Write-Host ""
    
    Write-Host " ┌── No Dia a Dia (Salvar alterações) ──────────────────────────────────────" -ForegroundColor $ColorHeader
    Write-Host "   git status                  " -NoNewline -ForegroundColor $ColorSuccess
    Write-Host "- Mostra quais arquivos foram criados ou modificados" -ForegroundColor $ColorText
    Write-Host "   git add .                   " -NoNewline -ForegroundColor $ColorSuccess
    Write-Host "- Adiciona todas as modificações para a fila (stage)" -ForegroundColor $ColorText
    Write-Host "   git commit -m \"Descrição\"  " -NoNewline -ForegroundColor $ColorSuccess
    Write-Host "- Cria um ponto de salvamento local com uma mensagem" -ForegroundColor $ColorText
    Write-Host ""
    
    Write-Host " ┌── Sincronizar com o GitHub ──────────────────────────────────────────────" -ForegroundColor $ColorHeader
    Write-Host "   git push origin main        " -NoNewline -ForegroundColor $ColorSuccess
    Write-Host "- Envia seus commits locais para o repositório no GitHub" -ForegroundColor $ColorText
    Write-Host "   git pull                    " -NoNewline -ForegroundColor $ColorSuccess
    Write-Host "- Baixa e mescla as alterações mais recentes do GitHub" -ForegroundColor $ColorText
    Write-Host " └──────────────────────────────────────────────────────────────────────────" -ForegroundColor $ColorHeader

    Press-AnyKey
}

# Opção 5: Segurança - Apagar Credenciais (LOGOUT)
function Option-LogoutGit {
    Write-Header
    Write-Host "   === OPÇÃO 5: LIMPEZA DE SEGURANÇA (LOGOUT DO GIT) ===" -ForegroundColor $ColorHeader
    Write-Host ""
    Write-Host " ATENÇÃO ALUNO:" -ForegroundColor $ColorWarning
    Write-Host " Como este computador é utilizado por outras turmas, deixar seu login" -ForegroundColor $ColorText
    Write-Host " do GitHub ativo representa um risco! O próximo aluno poderá acessar," -ForegroundColor $ColorText
    Write-Host " modificar ou apagar seus códigos no GitHub." -ForegroundColor $ColorText
    Write-Host ""
    Write-Host " Esta função irá:" -ForegroundColor $ColorMuted
    Write-Host "   1. Remover suas credenciais do GitHub salvas no Windows (Credential Manager)" -ForegroundColor $ColorMuted
    Write-Host "   2. Apagar as configurações globais de Nome e E-mail desta máquina" -ForegroundColor $ColorMuted
    Write-Host ""
    Write-Host " Deseja limpar seus dados agora por segurança? [s/N]: " -NoNewline -ForegroundColor $ColorWarning
    
    $confirm = Read-Host
    if ($confirm -match "^[SsPpYy]") {
        Write-Host "`n Iniciando processo de limpeza..." -ForegroundColor $ColorHeader
        
        # 1. Limpa as credenciais do Git usando o comando do próprio Git
        try {
            Write-Host " Removendo credenciais pelo Git Credential Helper..." -ForegroundColor $ColorText
            @("protocol=https", "host=github.com", "") | git credential reject 2>$null
            Write-Host " [OK] Credenciais limpas pelo Git." -ForegroundColor $ColorSuccess
        }
        catch {
            Write-Host " [!] O Git não conseguiu limpar as credenciais nativas, tentando alternativa..." -ForegroundColor $ColorWarning
        }
        
        # 2. Busca e remove credenciais no Credential Manager do Windows via cmdkey
        try {
            Write-Host " Varrendo o Gerenciador de Credenciais do Windows..." -ForegroundColor $ColorText
            $targets = cmdkey /list | Select-String "git:"
            if ($targets) {
                foreach ($tLine in $targets) {
                    if ($tLine -match "git:\S+") {
                        $targetName = $Matches[0]
                        Write-Host " Excluindo chave do Windows: $targetName" -ForegroundColor $ColorMuted
                        cmdkey /delete:$targetName | Out-Null
                    }
                }
                Write-Host " [OK] Todas as credenciais de Git salvas no Windows foram deletadas." -ForegroundColor $ColorSuccess
            } else {
                Write-Host " [OK] Nenhuma credencial do Windows encontrada." -ForegroundColor $ColorSuccess
            }
        }
        catch {
            Write-Host " [ERRO] Falha ao acessar o Gerenciador de Credenciais do Windows: $_" -ForegroundColor $ColorError
        }
        
        # 3. Limpa Nome, Email e Helper Global
        try {
            Write-Host " Removendo Nome de Usuário e Email globais..." -ForegroundColor $ColorText
            git config --global --unset user.name 2>$null
            git config --global --unset user.email 2>$null
            git config --global --unset credential.helper 2>$null
            Write-Host " [OK] Dados globais do Git desconfigurados." -ForegroundColor $ColorSuccess
        }
        catch {
            Write-Host " [ERRO] Falha ao limpar variáveis globais: $_" -ForegroundColor $ColorError
        }
        
        Write-Host ""
        Write-Host "┌─────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor $ColorSuccess
        Write-Host "│  LIMPEZA CONCLUÍDA! Suas credenciais foram apagadas com total segurança.    │" -ForegroundColor $ColorSuccess
        Write-Host "│  Você pode fechar a janela ou entregar a máquina para o próximo aluno.      │" -ForegroundColor $ColorSuccess
        Write-Host "└─────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor $ColorSuccess
    } else {
        Write-Host "`n Limpeza cancelada. Seus dados permanecem salvos no sistema." -ForegroundColor $ColorWarning
    }

    Press-AnyKey
}

# --- LOOP PRINCIPAL DO PROGRAMA ---

function Main-Menu {
    while ($true) {
        Write-Header
        
        # Mostra um status rápido no topo do menu
        $cfg = Get-GitConfig
        Write-Host " Status Atual: " -NoNewline -ForegroundColor $ColorText
        if ($cfg.Name -and $cfg.Email) {
            Write-Host "CONFIGURADO" -NoNewline -ForegroundColor $ColorSuccess
            Write-Host " ($($cfg.Name) | $($cfg.Email))" -ForegroundColor $ColorMuted
        } else {
            Write-Host "NÃO CONFIGURADO" -ForegroundColor $ColorError
        }
        Write-Host ""
        
        Write-Host " Escolha uma opção digitando o número correspondente:" -ForegroundColor $ColorMuted
        Write-Host ""
        
        Write-Host "  [1] Configurar Meu Git (Nome e E-mail para commits)" -ForegroundColor $ColorHeader
        Write-Host "  [2] Verificar Configuração Atual Completa" -ForegroundColor $ColorHeader
        Write-Host "  [3] Como Fazer Login/Autenticar no GitHub" -ForegroundColor $ColorHeader
        Write-Host "  [4] Tutorial Rápido de Comandos Básicos (Cola)" -ForegroundColor $ColorHeader
        Write-Host "  [5] Limpar Minhas Credenciais (LOGOUT - Segurança!)" -ForegroundColor $ColorWarning
        Write-Host "  [6] Sair" -ForegroundColor $ColorError
        
        Write-Footer
        
        Write-Host ""
        Write-Host " Digite sua opção >> " -NoNewline -ForegroundColor $ColorText
        $option = Read-Host
        
        switch ($option) {
            "1" { Option-ConfigureGit }
            "2" { Option-VerifyConfig }
            "3" { Option-GitHubAuth }
            "4" { Option-CheatSheet }
            "5" { Option-LogoutGit }
            "6" { 
                Write-Host "`n Obrigado por usar o Configurador Git! Bons estudos.`n" -ForegroundColor $ColorSuccess
                Start-Sleep -Seconds 1
                exit 
            }
            default {
                Write-Host "`n Opção inválida! Escolha um número de 1 a 6." -ForegroundColor $ColorError
                Start-Sleep -Seconds 1
            }
        }
    }
}

# Executa verificação inicial do Git antes de entrar no menu
Clear-Console
Write-Header
Write-Host " Carregando..." -ForegroundColor $ColorMuted
Start-Sleep -Milliseconds 300

if (Check-GitInstalled) {
    Main-Menu
} else {
    Write-Host " Pressione qualquer tecla para sair..." -ForegroundColor $ColorMuted
    $null = [Console]::ReadKey($true)
}
