# Projeto Final - Flask, MySQL e AWS com Terraform

Este projeto faz parte da Atividade 4 de Desenvolvimento Web. A aplicação Flask
deve ser executada em duas instâncias EC2, acessada por um servidor Nginx com
proxy reverso e conectada a uma instância EC2 separada com MySQL.

## Arquitetura atual

```text
Usuário
   |
   | HTTP - porta 80
   v
servidor-iago - Nginx
   |
   +--> app1-iago - Flask - porta 5000
   |
   +--> app2-iago - Flask - porta 5000
               |
               | Rede privada - porta 3306
               v
          db-iago - MySQL
```

## Recursos provisionados até agora

O diretório `TerraForm/` contém a infraestrutura AWS criada com Terraform.

- Uma instância EC2 para o Nginx:
  - Nome: `servidor-iago`
  - Função: proxy reverso
  - Porta pública HTTP: `80`
- Duas instâncias EC2 para o Flask:
  - Nome: `app1-iago`
  - Nome: `app2-iago`
  - Função: executar a aplicação Flask
  - Porta Flask: `5000`
- Uma instância EC2 para o banco MySQL:
  - Nome: `db-iago`
  - Função: armazenar os dados
  - Porta MySQL: `3306`
  - Sem IP público

## Segurança configurada

- O Security Group do Nginx permite HTTP público na porta `80`.
- O Security Group do Nginx permite SSH na porta `22`.
- O Security Group das duas aplicações permite a porta `5000` somente a partir
  do Security Group do Nginx.
- O Security Group do MySQL permite a porta `3306` somente a partir do
  Security Group das aplicações Flask.
- A instância do MySQL não possui IP público.
- A comunicação entre aplicação e banco deve utilizar o IP privado da DB.
- A porta `3306` não pode ser aberta para `0.0.0.0/0`.
- As credenciais AWS não são armazenadas nos arquivos Terraform.
- Os arquivos `.env` e os arquivos de estado do Terraform são ignorados pelo Git.

## Infraestrutura Terraform

### Arquivos principais

- `TerraForm/provider.tf`: provedor AWS e região `us-east-1`.
- `TerraForm/variable.tf`: variáveis de nomes, região, key pair e tipo de EC2.
- `TerraForm/main.tf`: AMI Ubuntu, Security Groups e instâncias EC2.
- `TerraForm/outputs.tf`: IPs públicos, IPs privados e IDs dos Security Groups.
- `TerraForm/.terraform.lock.hcl`: versões fixadas dos provedores Terraform.

### Comandos utilizados

```powershell
cd "C:\Users\Iago Lima\Desktop\GitHub\Projeto_final_DevWeb\TerraForm"

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
```

## Estado atual das instâncias

Os valores atuais obtidos pelo Terraform foram:

- Nginx público: `34.228.111.237`
- Aplicação 1 privada: `172.31.20.212`
- Aplicação 2 privada: `172.31.21.39`
- MySQL privado: `172.31.19.40`

Esses IPs podem mudar caso os laboratórios sejam reiniciados ou as instâncias
sejam recriadas.

## Configuração que ainda será feita

### Banco de dados

- Atualizar os pacotes da instância `db-iago`.
- Instalar e iniciar o MySQL.
- Configurar o MySQL para aceitar conexões na rede privada.
- Criar o banco da aplicação.
- Criar um usuário específico para o Flask.
- Conceder ao usuário privilégios somente sobre o banco da aplicação.
- Criar uma tabela com chave primária e pelo menos três campos.
- Testar a conexão a partir das duas instâncias Flask.

### Aplicações Flask

- Configurar o ambiente Python nas duas instâncias `app1-iago` e `app2-iago`.
- Clonar o projeto em ambas.
- Criar e ativar um ambiente virtual.
- Instalar as dependências do `requirements.txt`.
- Configurar as credenciais MySQL em um arquivo `.env`:
  - `DB_HOST`
  - `DB_PORT`
  - `DB_USER`
  - `DB_PASSWORD`
  - `DB_NAME`
- Criar as rotas `/cadastro` e `/listar`.
- Utilizar consultas parametrizadas para evitar SQL Injection.
- Implementar um formulário que herde `base.html`.
- Exibir os registros em uma página HTML.
- Executar o Flask na porta `5000`.

### Nginx

- Instalar o Nginx no servidor `servidor-iago`.
- Configurar o proxy reverso para HTTP.
- Distribuir as requisições entre `app1-iago` e `app2-iago`.
- Publicar o acesso pela porta `80`.
- Fazer o Flask continuar executando após encerrar a sessão SSH.

## Arquivos da aplicação atual

- `app.py`: aplicação Flask principal.
- `templates/`: páginas HTML.
- `static/`: CSS, JavaScript e imagens.
- `requirements.txt`: dependências Python.
- `.env.example`: modelo das variáveis do banco.
- `.gitignore`: arquivos e ambientes que não devem ser versionados.

## Próxima etapa

Preparar as instâncias por meio de scripts ou SSH manual para:

1. Instalar o MySQL na DB.
2. Criar banco, usuário e tabela.
3. Instalar Flask nas duas Apps.
4. Configurar o `.env` em cada App.
5. Configurar e iniciar o Nginx.
6. Testar cadastro e listagem.
7. Confirmar registros diretamente no MySQL.

## Segurança das credenciais

Os arquivos abaixo não devem ser enviados ao GitHub:

- `.env`
- Arquivos `.pem`
- `terraform.tfstate`
- `terraform.tfstate.backup`
- Credenciais AWS da pasta `.aws`
