# `db-iago` — MySQL

## Função e endereços

Armazena os pedidos enviados pelas duas Apps. As conexões de aplicação usam o
IP privado da instância.

Valores verificados em 22/11/2026:

- IP privado: `172.31.26.189`
- IP público atribuído pela subnet padrão: `34.207.152.96`
- Security Group: `sg-0ada88cd38a7beccc`
- Key pair EC2: `DevWeb_final`

A subnet padrão do laboratório atribui IP público à DB, mas o Security Group
não permite conexões SSH nem MySQL vindas da internet.

O IP público associado à DB não é necessário para as aplicações. Use sempre o
IP privado como `DB_HOST`.

## Regras de rede

- Entrada `22/tcp`: somente pelo Security Group das Apps
  (`sg-053f847cc3ac1e5b4`).
- Entrada `3306/tcp`: somente pelo Security Group das Apps
  (`sg-053f847cc3ac1e5b4`).
- Nenhuma regra `3306/tcp` para `0.0.0.0/0`.

O acesso administrativo é feito por SSH através de uma App, usando o IP
privado da DB como destino.

## MySQL

- Sistema: Ubuntu Server 22.04.
- Serviço: `mysql`, ativo e habilitado para iniciar com o sistema.
- Arquivo de configuração: `/etc/mysql/mysql.conf.d/mysqld.cnf`.
- `bind-address`: `172.31.26.189`.
- Porta: `3306`.
- Banco: `DragonBall`.
- Tabela: `pedidos`.
- Campos: `id INT AUTO_INCREMENT PRIMARY KEY` e `pedido VARCHAR(255) NOT NULL`.
- Usuário da aplicação: `flask_app`, sem usar `root` pela aplicação.
- As contas MySQL são restritas aos hosts `172.31.20.212` (App 1) e
  `172.31.21.39` (App 2).
- Privilégios: `SELECT` e `INSERT` somente em `DragonBall.pedidos`.

A senha do usuário MySQL não deve ser registrada nesta documentação. Ela fica
no `.env` local de cada App.

Instalação originalmente utilizada:

```bash
sudo apt update
sudo apt install -y mysql-server
```

## Operação e consultas

```bash
sudo systemctl status mysql
sudo systemctl start mysql
sudo systemctl restart mysql
sudo journalctl -u mysql -f
```

Contar pedidos:

```bash
sudo mysql -e "SELECT COUNT(*) FROM DragonBall.pedidos;"
```

Listar pedidos:

```bash
sudo mysql -e "SELECT id, pedido FROM DragonBall.pedidos ORDER BY id;"
```

## Conexão SSH administrativa

Como a DB não aceita SSH público, use a App 1 como salto:

```cmd
ssh -i "CAMINHO_DA_CHAVE\DevWeb_final.pem" -J ubuntu@IP_PUBLICO_APP1 ubuntu@172.31.26.189
```

Não publique nem compartilhe o arquivo `.pem`.
