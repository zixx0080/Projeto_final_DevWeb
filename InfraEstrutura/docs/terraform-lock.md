# .terraform.lock.hcl

O arquivo `.terraform.lock.hcl` é gerado pelo comando `terraform init`.

Ele fixa a versão exata do provedor AWS usada pelo projeto:

- provedor: `registry.terraform.io/hashicorp/aws`;
- versão: `5.100.0`;
- restrição declarada em `provider.tf`: `~> 5.0`.

O lock file também contém hashes de integridade. Esses hashes ajudam o
Terraform a detectar mudanças ou downloads incorretos do provedor.

## Manutenção

O arquivo normalmente deve ser mantido no controle de versão, pois garante que
outras pessoas usem o mesmo provedor compatível. Não edite manualmente a menos
que execute uma atualização controlada com Terraform.
