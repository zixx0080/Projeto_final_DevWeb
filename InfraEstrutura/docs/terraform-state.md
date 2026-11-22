# Estado do Terraform

O diretório `InfraEstrutura/` pode conter arquivos de estado locais gerados pelo
Terraform.

## Arquivos

- `terraform.tfstate`: estado principal;
- `terraform.tfstate.backup`: cópia anterior criada durante alterações.

Esses arquivos registram o estado conhecido dos recursos criados pela AWS,
incluindo IDs de instâncias e grupos de segurança.

## Informações sensíveis

Os arquivos de estado podem conter informações que não devem ser publicadas no
GitHub. Por isso, o `.gitignore` do projeto exclui:

- `InfraEstrutura/*.tfstate`;
- `InfraEstrutura/*.tfstate.backup`.

O estado local não substitui o recurso real da AWS. O Terraform compara o
arquivo de estado com o código `.tf` e o estado atual da AWS antes de calcular
um plano.

## Boas práticas

Em um projeto compartilhado ou em produção, o estado seria armazenado em um
backend remoto com controle de acesso e bloqueio. Neste laboratório, o projeto
usa estado local devido à sua configuração atual.
