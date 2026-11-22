# main.tf

O arquivo `main.tf` contém a infraestrutura principal: consulta de recursos
existentes, regras de rede e instâncias EC2.

## Dados consultados

### AMI Ubuntu

O bloco `aws_ami` pesquisa a AMI Ubuntu 22.04 Jammy mais recente publicada pela
Canonical na região selecionada. Ele utiliza o proprietário
`099720109477` e filtra imagens do tipo HVM.

Assim, o código não fixa manualmente o ID da AMI.

### VPC padrão

O bloco `aws_vpc` obtém a VPC padrão do AWS Academy. Todos os Security Groups
e instâncias são associados a essa VPC.

## Security Group do Nginx

O grupo `nginx-sg-iago` permite:

- HTTP na porta `80` para qualquer origem;
- SSH na porta `22` para o CIDR definido em `ssh_cidr`;
- saída para qualquer destino.

Ele protege o proxy reverso e cria a porta pública usada pelos usuários.

## Security Group das Apps

O grupo `app-sg-iago` permite:

- Flask na porta `5000` somente quando a origem pertence ao Security Group do
  Nginx;
- SSH na porta `22` pelo CIDR configurado;
- saída para qualquer destino.

Isso impede acesso direto público à porta Flask pela regra do Security Group,
mesmo que a instância tenha IP público.

## Security Group do banco

O grupo `db-sg-iago` permite:

- MySQL na porta `3306` somente quando a origem pertence ao Security Group das
  Apps;
- SSH na porta `22` somente quando a origem pertence ao Security Group das
  Apps;
- saída para qualquer destino.

A porta `3306` não aceita `0.0.0.0/0`.

## Instância Nginx

O recurso `aws_instance.nginx` cria `servidor-iago` com:

- Ubuntu obtido pelo `data.aws_ami.ubuntu`;
- tipo `t3.micro`;
- key pair `DevWeb_final`;
- Security Group do Nginx;
- endereço IP público.

O Elastic IP não é criado ou associado por este arquivo.

## Instâncias Flask

O recurso `aws_instance.app` usa `count = 2` e cria:

- `app1-iago` no índice `0`;
- `app2-iago` no índice `1`.

Cada instância recebe o tipo de instância, key pair e Security Group das Apps.
Os nomes vêm da lista `var.app_names`.

## Instância MySQL

O recurso `aws_instance.db` cria `db-iago` com o Security Group do banco e
solicita um IP público para a instância.

Embora a subnet possa atribuir IP público à DB, o Security Group não permite
MySQL ou SSH vindos diretamente da internet.
