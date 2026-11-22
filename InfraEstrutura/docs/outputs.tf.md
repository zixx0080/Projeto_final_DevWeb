# outputs.tf

O arquivo `outputs.tf` define informações exibidas pelo comando:

```powershell
terraform output
```

Os outputs não criam recursos; eles facilitam a consulta dos valores gerados
pelos recursos AWS.

## Saídas disponíveis

### `nginx_public_ip`

Retorna o IP público fixo associado ao Elastic IP do Nginx.

Usado para acessar a aplicação pelas rotas HTTP públicas.

### `app_public_ips`

Retorna uma lista com os IPs públicos das duas EC2 Flask.

### `app_private_ips`

Retorna uma lista com os IPs privados das duas EC2 Flask.

Esses valores são necessários para configurar os `upstream` ou destinos de
proxy do Nginx.

### `db_private_ip`

Retorna o IP privado da EC2 do MySQL.

Esse valor deve ser usado no `DB_HOST` do arquivo `.env` das duas aplicações.

### `security_group_ids`

Retorna um objeto com os IDs dos três grupos:

- `nginx`;
- `app`;
- `db`.

Os IDs são úteis para conferir a configuração na AWS ou usar os grupos em
expansões futuras da infraestrutura.

Os IPs públicos das EC2 podem mudar quando instâncias são recriadas ou reiniciadas.
Por isso, sempre confirme os valores atuais no console AWS ou por
`terraform output`.
