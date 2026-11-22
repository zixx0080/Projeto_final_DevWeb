# `servidor-iago` — Nginx

## Função

Recebe HTTP público na porta `80` e encaminha as requisições para as duas
instâncias Flask pelos endereços privados.

## Endereços atuais

Valores verificados em 22/11/2026:

- IP público: `54.84.203.179`
- IP privado: `172.31.31.189`
- Security Group: `sg-06418aa6f63f150c6`

O IP público pode mudar quando a instância é parada e iniciada. Consulte o
endereço atual em **EC2 → Instances**.

Conexão SSH pelo CMD do Windows:

```cmd
ssh -i "CAMINHO_DA_CHAVE\DevWeb_final.pem" ubuntu@IP_PUBLICO_NGINX
```

## Regras de rede

- Entrada `80/tcp`: qualquer origem (`0.0.0.0/0`).
- Entrada `22/tcp`: CIDR da variável Terraform `ssh_cidr`; atualmente
  `0.0.0.0/0`.
- Saída: permitida para qualquer destino.

Para produção, restrinja SSH ao seu IP público com máscara `/32`.

## Configuração realizada

- Sistema: Ubuntu Server 22.04.
- Pacote instalado: `nginx`.
- Arquivo de configuração: `/etc/nginx/sites-available/default`.
- Serviço: `nginx`, habilitado para iniciar com o sistema.
- O balanceamento padrão do Nginx envia tráfego ao upstream configurado:

Instalação originalmente utilizada:

```bash
sudo apt update
sudo apt install -y nginx
```

```nginx
upstream aplicacoes_flask {
    server 172.31.20.212:5000;
    server 172.31.21.39:5000;
}
```

As duas Apps usam o mesmo `server` com `proxy_pass http://aplicacoes_flask;`.
O estado atual não usa health check ativo; falhas são detectadas quando uma
requisição encontra um upstream indisponível.

## Comandos úteis

```bash
sudo systemctl status nginx
sudo systemctl start nginx
sudo systemctl restart nginx
sudo nginx -t
sudo systemctl reload nginx
sudo journalctl -u nginx -f
```

Teste local no próprio Nginx:

```bash
curl -i http://localhost/esferas
curl -i http://localhost/listar
```

## URLs públicas

- Página de Esferas: `http://IP_PUBLICO_NGINX/esferas`
- Pedidos em JSON: `http://IP_PUBLICO_NGINX/listar`
