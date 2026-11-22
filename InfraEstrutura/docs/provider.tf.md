# provider.tf

O arquivo `provider.tf` configura o Terraform para trabalhar com o provedor
AWS.

## Bloco `terraform`

```hcl
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
}
```

- `source` identifica o provedor oficial da AWS.
- `~> 5.0` permite versões compatíveis da linha 5.
- O arquivo `.terraform.lock.hcl` registra qual versão exata foi usada.

## Bloco `provider "aws"`

```hcl
provider "aws" {
  region = var.region
}
```

O provedor usa a variável `region`. Por padrão, essa variável é `us-east-1`.

O provedor obtém as credenciais temporárias pelo ambiente configurado no AWS
CLI ou no perfil AWS do laboratório. Credenciais não são escritas neste
arquivo.
