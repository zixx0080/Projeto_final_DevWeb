# `app2-iago` — Aplicação Flask

## Função e endereços

Executa a segunda cópia da aplicação Flask e participa do upstream do Nginx
usando a rede privada.

Valores verificados em 22/11/2026:

- IP público: `54.204.110.98`
- IP privado: `172.31.21.39`
- Security Group compartilhado pelas Apps: `sg-053f847cc3ac1e5b4`
- Key pair EC2: `DevWeb_final`

O IP público pode mudar ao parar e iniciar a instância. A chave privada `.pem`
fica somente no computador do proprietário e nunca deve ser publicada.

Conexão SSH pelo CMD do Windows:

```cmd
ssh -i "CAMINHO_DA_CHAVE\DevWeb_final.pem" ubuntu@IP_PUBLICO_APP2
```

## Regras de rede

- Entrada `22/tcp`: CIDR da variável Terraform `ssh_cidr`; atualmente
  `0.0.0.0/0`.
- Entrada `5000/tcp`: somente do Security Group do Nginx
  (`sg-06418aa6f63f150c6`).
- Saída: permitida para qualquer destino.

Para produção, restrinja SSH ao seu IP público com máscara `/32`.

## Aplicação e ambiente

- Repositório: `https://github.com/zixx0080/Projeto_final_DevWeb`
- Diretório: `/home/ubuntu/Projeto_final_DevWeb`
- Ambiente virtual: `/home/ubuntu/Projeto_final_DevWeb/.venv`
- Dependências: `requirements.txt`
- Arquivo de ambiente: `/home/ubuntu/Projeto_final_DevWeb/.env`
- O `.env` é local, tem permissão `600` e não é versionado.

Pacotes de sistema instalados:

```bash
sudo apt update
sudo apt install -y git python3-venv python3-pip mysql-client
```

Preparação do projeto:

```bash
git clone https://github.com/zixx0080/Projeto_final_DevWeb.git
cd Projeto_final_DevWeb
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

Variáveis usadas no `.env`:

```env
DB_HOST=IP_PRIVADO_DA_DB
DB_PORT=3306
DB_USER=flask_app
DB_PASSWORD=SEGREDO_LOCAL_NAO_VERSIONADO
DB_NAME=DragonBall
```

A aplicação usa PyMySQL e `python-dotenv`. A página `/esferas` insere o pedido
com uma consulta parametrizada; `/listar` consulta `id` e `pedido` e responde
em JSON.

## Serviço persistente

- Serviço systemd: `dragonball-flask.service`
- Inicialização: habilitado e ativo.
- Diretório de trabalho: `/home/ubuntu/Projeto_final_DevWeb`
- Executável: `.venv/bin/python app.py`
- Porta: `5000`

Comandos:

```bash
sudo systemctl status dragonball-flask.service
sudo systemctl start dragonball-flask.service
sudo systemctl restart dragonball-flask.service
sudo systemctl enable dragonball-flask.service
sudo journalctl -u dragonball-flask.service -f
```

Atualizar o código:

```bash
cd ~/Projeto_final_DevWeb
git pull origin main
sudo systemctl restart dragonball-flask.service
```

Teste local:

```bash
curl -i http://localhost:5000/esferas
curl -i http://localhost:5000/listar
```
