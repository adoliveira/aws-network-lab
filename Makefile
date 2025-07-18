# Makefile para AWS Network Lab

.PHONY: help init validate plan apply destroy clean format check

# Variáveis
TF_VAR_FILE ?= terraform.tfvars
MODULE_DIR = module

help: ## Mostra este help
	@echo "Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

init: ## Inicializa o Terraform
	@echo "🔄 Inicializando Terraform..."
	cd $(MODULE_DIR) && terraform init

validate: ## Valida a configuração
	@echo "✅ Validando configuração..."
	./validate.sh

format: ## Formata o código Terraform
	@echo "📝 Formatando código..."
	cd $(MODULE_DIR) && terraform fmt -recursive

check: format validate ## Executa format e validate

plan: check ## Planeja as mudanças
	@echo "📋 Planejando mudanças..."
	cd $(MODULE_DIR) && terraform plan -var-file=$(TF_VAR_FILE) -out=tfplan

apply: ## Aplica as mudanças
	@echo "🚀 Aplicando mudanças..."
	@if [ ! -f $(MODULE_DIR)/tfplan ]; then \
		echo "❌ Arquivo tfplan não encontrado. Execute 'make plan' primeiro."; \
		exit 1; \
	fi
	cd $(MODULE_DIR) && terraform apply tfplan
	@rm -f $(MODULE_DIR)/tfplan

deploy: plan apply ## Planeja e aplica (deploy completo)

destroy-plan: ## Planeja a destruição
	@echo "🗑️  Planejando destruição..."
	cd $(MODULE_DIR) && terraform plan -destroy -var-file=$(TF_VAR_FILE) -out=destroy.tfplan

destroy: destroy-plan ## Destrói a infraestrutura
	@echo "💥 Destruindo infraestrutura..."
	@echo "⚠️  ATENÇÃO: Esta ação é IRREVERSÍVEL!"
	@read -p "Digite 'yes' para confirmar: " confirm && [ "$$confirm" = "yes" ]
	cd $(MODULE_DIR) && terraform apply destroy.tfplan
	@rm -f $(MODULE_DIR)/destroy.tfplan

clean: ## Remove arquivos temporários
	@echo "🧹 Limpando arquivos temporários..."
	rm -f $(MODULE_DIR)/tfplan $(MODULE_DIR)/destroy.tfplan
	rm -rf $(MODULE_DIR)/.terraform/

setup: ## Setup inicial (cria terraform.tfvars)
	@if [ ! -f $(MODULE_DIR)/terraform.tfvars ]; then \
		echo "📝 Criando terraform.tfvars..."; \
		cp $(MODULE_DIR)/terraform.tfvars.example $(MODULE_DIR)/terraform.tfvars; \
		echo "✅ Arquivo terraform.tfvars criado. Edite conforme necessário."; \
	else \
		echo "✅ terraform.tfvars já existe."; \
	fi

outputs: ## Mostra os outputs
	@cd $(MODULE_DIR) && terraform output

state-list: ## Lista recursos no state
	@cd $(MODULE_DIR) && terraform state list

cost-estimate: ## Estima custos (requer infracost)
	@if command -v infracost >/dev/null 2>&1; then \
		cd $(MODULE_DIR) && infracost breakdown --path .; \
	else \
		echo "❌ infracost não está instalado. Visite: https://www.infracost.io/docs/"; \
	fi

docs: ## Gera documentação (requer terraform-docs)
	@if command -v terraform-docs >/dev/null 2>&1; then \
		cd $(MODULE_DIR) && terraform-docs markdown table --output-file ../TERRAFORM.md .; \
		echo "✅ Documentação gerada em TERRAFORM.md"; \
	else \
		echo "❌ terraform-docs não está instalado. Visite: https://terraform-docs.io/"; \
	fi
