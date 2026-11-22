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
   |           |
   +--> app2-iago - Flask - porta 5000
               |
               | Rede privada - porta 3306
               v
          db-iago - MySQL
```

## Recursos provisionados até agora

O diretório `InfraEstrutura/` contém a infraestrutura AWS criada com Terraform.

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
  - Comunicação do MySQL restrita ao Security Group das aplicações

## Segurança configurada

- O Security Group do Nginx permite HTTP público na porta `80`.
- O Security Group do Nginx permite SSH na porta `22`.
- O Security Group das duas aplicações permite a porta `5000` somente a partir
  do Security Group do Nginx.
- O Security Group do MySQL permite a porta `3306` somente a partir do
  Security Group das aplicações Flask.
- A porta SSH `22` da instância MySQL também aceita conexões somente a partir
  do Security Group das aplicações Flask; o acesso administrativo é feito por
  meio de uma instância App.
- A subnet padrão do laboratório atribui IP público à DB, mas as portas `22` e
  `3306` não aceitam conexões vindas da internet.
- A comunicação entre aplicação e banco deve utilizar o IP privado da DB.
- A porta `3306` não pode ser aberta para `0.0.0.0/0`.
- As credenciais AWS não são armazenadas nos arquivos Terraform.
- Os arquivos `.env` e os arquivos de estado do Terraform são ignorados pelo Git.

## Infraestrutura Terraform

### Arquivos principais

- `InfraEstrutura/provider.tf`: provedor AWS e região `us-east-1`.
- `InfraEstrutura/variable.tf`: variáveis de nomes, região, key pair e tipo de EC2.
- `InfraEstrutura/main.tf`: AMI Ubuntu, Security Groups e instâncias EC2.
- `InfraEstrutura/outputs.tf`: IPs públicos, IPs privados e IDs dos Security Groups.
- `InfraEstrutura/.terraform.lock.hcl`: versões fixadas dos provedores Terraform.

### Comandos utilizados

```powershell
cd "C:\Users\Iago Lima\Desktop\GitHub\Projeto_final_DevWeb\InfraEstrutura"

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
```

## Estado atual das instâncias

Endereços atuais verificados na AWS:

- Nginx público: `54.84.203.179`
- Aplicação 1 pública: `54.173.49.64`
- Aplicação 2 pública: `54.204.110.98`
- Aplicação 1 privada: `172.31.20.212`
- Aplicação 2 privada: `172.31.21.39`
- MySQL privado: `172.31.26.189`
- MySQL público atribuído pela subnet: `34.207.152.96`

Esses IPs podem mudar caso os laboratórios sejam reiniciados ou as instâncias
sejam recriadas.

## Configuração que ainda será feita

### Banco de dados

- Concluído: MySQL instalado e ativo na instância `db-iago`.
- Concluído: MySQL configurado para aceitar conexões no IP privado da DB.
- Concluído: banco `DragonBall` e tabela `pedidos` criados.
- Concluído: usuário `flask_app` configurado para os IPs privados das duas Apps,
  com privilégios `SELECT` e `INSERT` na tabela `pedidos`.
- Concluído: conexão Python–MySQL testada a partir das duas Apps.
- Concluído: pedido enviado pela URL pública confirmado na tabela MySQL.

### Tabela atual

A tabela `DragonBall.pedidos` contém:

| Coluna | Tipo | Descrição |
| --- | --- | --- |
| `id` | `INT` | Chave primária, incremento automático |
| `pedido` | `VARCHAR(255)` | Texto do pedido |

Esta tabela tem somente uma coluna além da chave primária. O enunciado da
atividade pede uma chave primária e três campos; a estrutura atual foi mantida
conforme a decisão do projeto, mas pode não cumprir esse requisito de avaliação.

### Aplicações Flask

- Implementado localmente: o formulário existente na página `/esferas` envia o
  pedido à tabela `pedidos` usando consulta parametrizada.
- Concluído: App 1 e App 2 preparadas com ambiente virtual, dependências e
  `.env` local.
- Concluído: serviços `systemd` `dragonball-flask.service` habilitados nas
  duas Apps.
- Concluído: envio de pedido pela página pública `/esferas` verificado.
- Implementado e publicado: `GET /listar` retorna os pedidos em JSON sem
  alterar a interface existente.
- Concluído: código atualizado e serviço reiniciado na App 1.
- Concluído: App 2 sincronizada com `main`; serviço `systemd` está `active`.
- Concluído: `/listar` respondeu HTTP `200` com `application/json` pelo Nginx.
- Concluído: cinco pedidos enviados pela página pública e confirmados no MySQL.
- Observação: o PDF pede uma página HTML com tabela; retornar JSON diverge desse
  requisito e pode não atender ao critério de avaliação.

### Nginx

- Concluído: Nginx instalado e configurado como proxy reverso na porta `80`.
- Concluído: tráfego encaminhado às duas Apps pelos IPs privados.
- Concluído: URL pública `/esferas` respondeu com HTTP `200`.
- Concluído: rota pública `/listar` respondeu HTTP `200` como JSON.

## Arquivos da aplicação atual

- `app.py`: aplicação Flask principal.
- `templates/`: páginas HTML.
- `static/`: CSS, JavaScript e imagens.
- `requirements.txt`: dependências Python.
- `.env.example`: modelo das variáveis do banco.
- `.gitignore`: arquivos e ambientes que não devem ser versionados.

## Próximas etapas

1. Verificar que o site continua disponível após fechar todas as sessões SSH.
2. Salvar evidência visual do `SELECT` mostrando os cinco pedidos no MySQL.
3. Salvar evidência das regras de entrada do Security Group da DB.
4. Confirmar os links públicos e o repositório para entrega.
5. Avaliar com o professor se o endpoint JSON atende ao requisito de listagem HTML.

Para testar a resposta pública JSON pelo CMD do Windows:

```cmd
curl.exe -sS -o NUL -w "HTTP %{http_code} | %{content_type}\n" http://54.84.203.179/listar
```

O endpoint foi verificado com HTTP `200` e `application/json`. Se o IP público do Nginx mudar,
substitua-o pelo endereço atual da instância `servidor-iago`.


## Segurança das credenciais

Os arquivos abaixo não devem ser enviados ao GitHub:

- `.env`
- Arquivos `.pem`
- `terraform.tfstate`
- `terraform.tfstate.backup`
- Credenciais AWS da pasta `.aws`
