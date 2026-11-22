# variable.tf

O arquivo `variable.tf` centraliza valores parametrizáveis da infraestrutura.

## Variáveis principais

| Variável | Valor padrão | Função |
| --- | --- | --- |
| `region` | `us-east-1` | Região dos recursos AWS |
| `student_name` | `iago` | Prefixo dos nomes dos Security Groups |
| `nginx_name` | `servidor-iago` | Nome da EC2 do Nginx |
| `app_names` | `app1-iago`, `app2-iago` | Nomes das duas EC2 Flask |
| `db_name` | `db-iago` | Nome da EC2 do MySQL |
| `key_pair_name` | `DevWeb_final` | Nome do key pair já criado na AWS |
| `instance_type` | `t3.micro` | Tipo das instâncias EC2 |
| `app_count` | `2` | Quantidade de instâncias Flask |
| `ssh_cidr` | `0.0.0.0/0` | Rede autorizada a usar SSH nas EC2 |
| `nginx_elastic_ip_allocation_id` | ID configurado do Elastic IP | Allocation ID associado ao Nginx |

## Validações

A variável `app_count` aceita somente o valor `2`, pois a arquitetura foi
planejada com duas instâncias Flask.

A variável `ssh_cidr` precisa ser um CIDR válido, por exemplo:

- `0.0.0.0/0` para permitir SSH de qualquer origem;
- `203.0.113.10/32` para permitir somente um IP específico.

O valor padrão de `ssh_cidr` permite acesso público para o laboratório. Em um
ambiente real, deve ser restrito ao IP público do administrador.

## Segurança do key pair

`key_pair_name` contém apenas o nome do par de chaves. O conteúdo do arquivo
`.pem` não é armazenado no Terraform. O arquivo privado deve permanecer em uma
localização segura no computador do responsável pela infraestrutura.
