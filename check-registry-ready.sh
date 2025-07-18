#!/bin/bash

# Script para verificar se o módulo está pronto para publicação no Terraform Registry
# Uso: ./check-registry-ready.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Contadores
PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

# Funções de logging
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_pass() {
    echo -e "${GREEN}✅ $1${NC}"
    PASS_COUNT=$((PASS_COUNT + 1))
}

log_fail() {
    echo -e "${RED}❌ $1${NC}"
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

log_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    WARN_COUNT=$((WARN_COUNT + 1))
}

# Verificar arquivos obrigatórios
check_required_files() {
    log_info "Verificando arquivos obrigatórios para Terraform Registry..."
    
    required_files=(
        "main.tf"
        "variables.tf"
        "outputs.tf"
        "versions.tf"
        "README.md"
        "LICENSE"
    )
    
    for file in "${required_files[@]}"; do
        if [[ -f "$file" ]]; then
            log_pass "Arquivo $file encontrado"
        else
            log_fail "Arquivo obrigatório $file não encontrado"
        fi
    done
}

# Verificar estrutura de variáveis
check_variables_structure() {
    log_info "Verificando estrutura do arquivo variables.tf..."
    
    if [[ -f "variables.tf" ]]; then
        # Verificar se há descrições nas variáveis
        if grep -q 'description.*=.*"' variables.tf; then
            log_pass "Variáveis têm descrições"
        else
            log_fail "Variáveis devem ter descrições para o registry"
        fi
        
        # Verificar se há tipos definidos
        if grep -q 'type.*=' variables.tf; then
            log_pass "Variáveis têm tipos definidos"
        else
            log_warn "Recomendado: definir tipos para todas as variáveis"
        fi
    fi
}

# Verificar estrutura de outputs
check_outputs_structure() {
    log_info "Verificando estrutura do arquivo outputs.tf..."
    
    if [[ -f "outputs.tf" ]]; then
        # Verificar se há descrições nos outputs
        if grep -q 'description.*=.*"' outputs.tf; then
            log_pass "Outputs têm descrições"
        else
            log_fail "Outputs devem ter descrições para o registry"
        fi
    fi
}

# Verificar versioning
check_versioning() {
    log_info "Verificando configuração de versões..."
    
    if [[ -f "versions.tf" ]]; then
        # Verificar versão mínima do Terraform
        if grep -q 'required_version.*=' versions.tf; then
            log_pass "Versão mínima do Terraform especificada"
        else
            log_fail "Deve especificar versão mínima do Terraform"
        fi
        
        # Verificar versões dos providers
        if grep -q 'required_providers' versions.tf; then
            log_pass "Providers com versões especificadas"
        else
            log_fail "Deve especificar versões dos providers"
        fi
    fi
}

# Verificar exemplos
check_examples() {
    log_info "Verificando exemplos..."
    
    if [[ -d "examples" ]]; then
        log_pass "Diretório examples/ encontrado"
        
        # Verificar se há pelo menos um exemplo
        example_count=$(find examples -name "main.tf" | wc -l)
        if [[ $example_count -gt 0 ]]; then
            log_pass "$example_count exemplo(s) encontrado(s)"
        else
            log_warn "Recomendado: adicionar exemplos práticos"
        fi
    else
        log_warn "Recomendado: adicionar diretório examples/ com exemplos de uso"
    fi
}

# Verificar documentação
check_documentation() {
    log_info "Verificando documentação..."
    
    if [[ -f "README.md" ]]; then
        # Verificar tamanho do README
        readme_lines=$(wc -l < README.md)
        if [[ $readme_lines -gt 50 ]]; then
            log_pass "README.md é abrangente ($readme_lines linhas)"
        else
            log_warn "README.md deveria ser mais detalhado (atual: $readme_lines linhas)"
        fi
        
        # Verificar se há exemplos de uso no README
        if grep -q '```hcl' README.md; then
            log_pass "README contém exemplos de código"
        else
            log_warn "Recomendado: adicionar exemplos de uso no README"
        fi
    fi
    
    # Verificar terraform-docs
    if [[ -f ".terraform-docs.yml" ]]; then
        log_pass "Configuração terraform-docs encontrada"
    else
        log_warn "Recomendado: configurar terraform-docs para documentação automática"
    fi
}

# Verificar CI/CD
check_cicd() {
    log_info "Verificando pipeline CI/CD..."
    
    if [[ -f ".github/workflows/terraform-module.yml" ]]; then
        log_pass "GitHub Actions workflow configurado"
    else
        log_warn "Recomendado: configurar CI/CD para validação automática"
    fi
    
    if [[ -f ".releaserc.json" ]]; then
        log_pass "Semantic release configurado"
    else
        log_warn "Recomendado: configurar semantic release"
    fi
}

# Verificar validação Terraform
check_terraform_validation() {
    log_info "Verificando validação Terraform..."
    
    if command -v terraform &> /dev/null; then
        # Verificar formato
        if terraform fmt -check -recursive &> /dev/null; then
            log_pass "Código Terraform formatado corretamente"
        else
            log_fail "Execute 'terraform fmt -recursive' para formatar o código"
        fi
        
        # Tentar validação (sem backend)
        if terraform init -backend=false &> /dev/null && terraform validate &> /dev/null; then
            log_pass "Código Terraform é válido"
        else
            log_fail "Código Terraform tem erros de validação"
        fi
    else
        log_warn "Terraform não encontrado - não foi possível validar"
    fi
}

# Verificar estrutura de tags
check_git_tags() {
    log_info "Verificando tags Git..."
    
    if git tag &> /dev/null; then
        # Verificar se há tags
        tag_count=$(git tag | wc -l)
        if [[ $tag_count -gt 0 ]]; then
            # Verificar formato das tags
            if git tag | grep -q '^v[0-9]\+\.[0-9]\+\.[0-9]\+$'; then
                log_pass "Tags seguem semantic versioning"
            else
                log_warn "Tags devem seguir formato semantic versioning (v1.0.0)"
            fi
        else
            log_warn "Nenhuma tag encontrada - crie uma tag para a primeira versão"
        fi
    else
        log_warn "Não é um repositório Git ou sem tags"
    fi
}

# Verificar descrição
check_module_description() {
    log_info "Verificando descrição do módulo..."
    
    if [[ -f "README.md" ]]; then
        # Verificar se há uma descrição clara no início
        if head -n 10 README.md | grep -q -i "terraform\|infrastructure\|aws"; then
            log_pass "README contém descrição clara do módulo"
        else
            log_warn "Recomendado: adicionar descrição clara do módulo no início do README"
        fi
    fi
}

# Verificar lista de arquivos desnecessários
check_unwanted_files() {
    log_info "Verificando arquivos desnecessários..."
    
    unwanted_patterns=(
        "*.tfstate"
        "*.tfstate.backup"
        ".terraform"
        "*.tfvars"
        "terraform.tfvars"
        "override.tf"
        "override.tf.json"
        "*_override.tf"
        "*_override.tf.json"
    )
    
    has_unwanted=false
    for pattern in "${unwanted_patterns[@]}"; do
        if find . -name "$pattern" -type f | grep -q .; then
            log_fail "Encontrado arquivo que não deveria estar no módulo: $pattern"
            has_unwanted=true
        fi
    done
    
    if ! $has_unwanted; then
        log_pass "Nenhum arquivo desnecessário encontrado"
    fi
    
    # Verificar .gitignore
    if [[ -f ".gitignore" ]]; then
        log_pass "Arquivo .gitignore encontrado"
    else
        log_warn "Recomendado: adicionar .gitignore para ignorar arquivos temporários"
    fi
}

# Resumo final
show_summary() {
    echo ""
    echo "==========================================="
    log_info "RESUMO DA VERIFICAÇÃO"
    echo "==========================================="
    echo ""
    echo "✅ Verificações OK: $PASS_COUNT"
    echo "⚠️  Avisos: $WARN_COUNT"
    echo "❌ Falhas: $FAIL_COUNT"
    echo ""
    
    if [[ $FAIL_COUNT -eq 0 ]]; then
        if [[ $WARN_COUNT -eq 0 ]]; then
            log_pass "🎉 PERFEITO! Módulo está totalmente pronto para o Terraform Registry!"
        else
            log_pass "✅ BOM! Módulo está pronto para o registry com algumas recomendações."
        fi
        echo ""
        echo "Próximos passos:"
        echo "1. Execute: ./release.sh v1.0.0"
        echo "2. Aguarde o CI/CD completar"
        echo "3. Publique no registry.terraform.io"
    else
        log_fail "❌ AÇÃO NECESSÁRIA! Corrija as falhas antes de publicar."
        echo ""
        echo "Depois de corrigir as falhas, execute novamente este script."
    fi
    
    echo ""
    echo "==========================================="
}

# Função principal
main() {
    echo "🔍 Verificando se o módulo está pronto para o Terraform Registry"
    echo ""
    
    check_required_files
    echo ""
    check_variables_structure
    echo ""
    check_outputs_structure
    echo ""
    check_versioning
    echo ""
    check_examples
    echo ""
    check_documentation
    echo ""
    check_cicd
    echo ""
    check_terraform_validation
    echo ""
    check_git_tags
    echo ""
    check_module_description
    echo ""
    check_unwanted_files
    
    show_summary
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
