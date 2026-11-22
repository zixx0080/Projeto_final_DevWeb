# Documentação da infraestrutura Terraform

Esta pasta documenta os arquivos usados para criar a infraestrutura AWS do
projeto. A configuração atual encontra-se em `InfraEstrutura/` e utiliza o
Terraform com o provedor AWS.

## Visão geral

O Terraform cria:

- 1 instância EC2 para o proxy reverso Nginx;
- 2 instâncias EC2 para a aplicação Flask;
- 1 instância EC2 para o MySQL;
- 3 Security Groups com regras de entrada e saída;
- os IDs e endereços usados como informações de saída.

Os servidores usam Ubuntu Server 22.04, o tipo de instância
`t3.micro` e o key pair `DevWeb_final`. A configuração usa a VPC padrão da região
`us-east-1`.

Não são gerados pelo Terraform:

- a instalação do Nginx, Flask ou MySQL;
- os arquivos de aplicação e o ambiente virtual;
- o banco `DragonBall`, o usuário `flask_app` e as tabelas;
- a criação do Elastic IP associado ao Nginx;
- o vínculo entre a aplicação e o banco por meio do arquivo `.env`.

Essas etapas são configuradas manualmente nas EC2 depois da criação.

## Arquivos explicados

- [provider.tf](./provider.tf.md) - define o provedor AWS e a região.
- [variable.tf](./variable.tf.md) - declara nomes, região, key pair e regras.
- [main.tf](./main.tf.md) - cria a imagem Ubuntu, os Security Groups e as EC2.
- [outputs.tf](./outputs.tf.md) - mostra endereços e IDs após o `apply`.
- [.terraform.lock.hcl](./terraform-lock.md) - fixa o provedor usado pelo projeto.
- [Estado do Terraform](./terraform-state.md) - explica os arquivos de estado locais.

## Fluxo de uso

Na pasta `InfraEstrutura`, os comandos principais são:

```powershell
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
```

- `init` prepara o diretório e baixa o provedor AWS.
- `fmt` padroniza a formatação dos arquivos `.tf`.
- `validate` verifica se a configuração está sintaticamente correta.
- `plan` mostra o que será criado, alterado ou destruído.
- `apply` cria ou altera os recursos da AWS.
- `output` exibe os valores definidos em `outputs.tf`.

## Ordem dos recursos

Os recursos dependem uns dos outros por referência:

1. `provider.tf` seleciona o provedor e a região.
2. `main.tf` localiza o Ubuntu e a VPC padrão.
3. Os Security Groups são criados.
4. Cada Security Group usa o ID dos grupos aos quais deve permitir acesso.
5. As instâncias EC2 recebem seus grupos de segurança e key pair.
6. `outputs.tf` publica os IPs e IDs úteis após a aplicação.
