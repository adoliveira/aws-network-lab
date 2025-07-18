#!/bin/bash

# Script para preparar e publicar o módulo no Terraform Registry
# Uso: ./release.sh [version]

set -e

VERSION=${1:-""}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções de logging
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar se estamos na branch main
check_branch() {
    local current_branch=$(git branch --show-current)
    if [[ "$current_branch" != "main" ]]; then
        log_error "Você deve estar na branch 'main' para fazer o release"
        exit 1
    fi
    log_success "Branch 'main' verificada"
}

# Verificar se há mudanças não commitadas
check_git_status() {
    if [[ -n $(git status --porcelain) ]]; then
        log_error "Há mudanças não commitadas. Faça commit antes do release"
        git status --short
        exit 1
    fi
    log_success "Working directory limpo"
}

# Validar formato da versão
validate_version() {
    if [[ -z "$VERSION" ]]; then
        log_error "Versão é obrigatória. Uso: $0 <version>"
        echo "Exemplo: $0 v1.0.0"
        exit 1
    fi
    
    if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        log_error "Versão deve seguir o formato semantic versioning: v1.0.0"
        exit 1
    fi
    log_success "Versão $VERSION validada"
}

# Verificar se a tag já existe
check_tag_exists() {
    if git tag -l | grep -q "^$VERSION$"; then
        log_error "Tag $VERSION já existe"
        exit 1
    fi
    log_success "Tag $VERSION disponível"
}

# Validar Terraform
validate_terraform() {
    log_info "Validando configuração Terraform..."
    
    terraform fmt -check -recursive
    if [[ $? -ne 0 ]]; then
        log_error "Terraform format check falhou"
        exit 1
    fi
    
    terraform init -backend=false > /dev/null
    terraform validate
    if [[ $? -ne 0 ]]; then
        log_error "Terraform validate falhou"
        exit 1
    fi
    
    log_success "Validação Terraform OK"
}

# Verificar estrutura do módulo para registry
check_module_structure() {
    log_info "Verificando estrutura do módulo..."
    
    required_files=("main.tf" "variables.tf" "outputs.tf" "versions.tf" "README.md")
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            log_error "Arquivo obrigatório não encontrado: $file"
            exit 1
        fi
    done
    
    log_success "Estrutura do módulo OK"
}

# Atualizar documentação
update_docs() {
    log_info "Atualizando documentação..."
    
    if command -v terraform-docs &> /dev/null; then
        terraform-docs markdown table --output-file TERRAFORM_DOCS.md .
        log_success "Documentação atualizada"
    else
        log_warning "terraform-docs não encontrado. Documentação será gerada no CI/CD"
    fi
}

# Executar testes básicos
run_tests() {
    log_info "Executando testes básicos..."
    
    # Teste de plan para exemplo single-region
    if [[ -d "examples/single-region" ]]; then
        cd examples/single-region
        terraform init -backend=false > /dev/null
        terraform plan > /dev/null
        if [[ $? -ne 0 ]]; then
            log_error "Teste do exemplo single-region falhou"
            exit 1
        fi
        cd - > /dev/null
        log_success "Teste single-region OK"
    fi
    
    # Teste de plan para exemplo multi-region
    if [[ -d "examples/multi-region" ]]; then
        cd examples/multi-region
        terraform init -backend=false > /dev/null
        terraform plan > /dev/null
        if [[ $? -ne 0 ]]; then
            log_error "Teste do exemplo multi-region falhou"
            exit 1
        fi
        cd - > /dev/null
        log_success "Teste multi-region OK"
    fi
}

# Criar e enviar tag
create_release() {
    log_info "Criando release $VERSION..."
    
    # Criar tag anotada
    git tag -a "$VERSION" -m "Release $VERSION"
    
    # Push da tag
    git push origin "$VERSION"
    
    log_success "Tag $VERSION criada e enviada"
    log_info "GitHub Actions irá automaticamente:"
    echo "  - Validar o módulo"
    echo "  - Executar testes"
    echo "  - Gerar documentação"
    echo "  - Criar release no GitHub"
    echo "  - Preparar para publicação no Terraform Registry"
}

# Mostrar próximos passos
show_next_steps() {
    echo ""
    log_info "🎉 Release $VERSION iniciado com sucesso!"
    echo ""
    echo "📋 Próximos passos:"
    echo "1. Aguarde o GitHub Actions completar (https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^/]*\/[^/]*\)\.git/\1/')/actions)"
    echo "2. Verifique o release criado (https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^/]*\/[^/]*\)\.git/\1/')/releases)"
    echo "3. Para publicar no Terraform Registry:"
    echo "   - Acesse: https://registry.terraform.io/"
    echo "   - Faça login com GitHub"
    echo "   - Clique em 'Publish Module'"
    echo "   - Selecione este repositório"
    echo ""
    log_success "Módulo estará disponível em: registry.terraform.io/modules/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^/]*\/[^/]*\)\.git/\1/')"
}

# Função principal
main() {
    echo "🚀 Preparando release do módulo Terraform para o Registry"
    echo ""
    
    validate_version
    check_branch
    check_git_status
    check_tag_exists
    check_module_structure
    validate_terraform
    update_docs
    run_tests
    create_release
    show_next_steps
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
