// Região onde os recursos AWS serão criados.
variable "region" {
  description = "Região AWS utilizada pelo laboratório AWS Academy"
  type        = string
  default     = "us-east-1"
}

// Nome usado na configuração da instância padrão.
variable "student_name" {
  description = "Nome usado para identificar a atividade no Terraform"
  type        = string
  default     = "iago"
}

// Nome do proxy reverso Nginx que receberá o tráfego público.
variable "nginx_name" {
  description = "Nome da instância EC2 responsável pelo Nginx"
  type        = string
  default     = "servidor-iago"
}

// Nomes das duas instâncias que executarão a aplicação Flask.
variable "app_names" {
  description = "Lista com os nomes das instâncias da aplicação Flask"
  type        = list(string)
  default     = ["app1-iago", "app2-iago"]
}

// Nome da instância responsável pelo banco de dados MySQL.
variable "db_name" {
  description = "Nome da instância EC2 responsável pelo MySQL"
  type        = string
  default     = "db-iago"
}

// Key pair existente em EC2 > Network & Security > Key Pairs.
// Nunca coloque o conteúdo do arquivo PEM privado no Terraform ou no Git.
variable "key_pair_name" {
  description = "Nome do key pair EC2 existente, sem a extensão .pem"
  type        = string
  default     = "DevWeb_final"
}

// Tipo elegível ao nível gratuito no laboratório.
variable "instance_type" {
  description = "Tipo da instância EC2 dos servidores App e DB"
  type        = string
  default     = "t3.micro"
}

// Quantidade fixa de servidores Flask nesta arquitetura.
variable "app_count" {
  description = "Quantidade de instâncias da aplicação Flask"
  type        = number
  default     = 2

  validation {
    condition     = var.app_count == 2
    error_message = "Esta atividade foi planejada para exatamente duas instâncias Flask."
  }
}

// Origem permitida para conexões SSH nas instâncias.
// Para maior segurança, substitua por seu IP público no formato /32.
variable "ssh_cidr" {
  description = "IP ou rede autorizada a acessar a porta SSH 22"
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrnetmask(var.ssh_cidr))
    error_message = "ssh_cidr deve ser um CIDR válido, como 203.0.113.10/32."
  }
}

// Allocation ID do Elastic IP já criado e associado ao laboratório.
variable "nginx_elastic_ip_allocation_id" {
  description = "Allocation ID do Elastic IP associado ao servidor Nginx"
  type        = string
  default     = "eipalloc-06078a6ff8710c5bf"

  validation {
    condition     = can(regex("^eipalloc-[0-9a-f]+$", var.nginx_elastic_ip_allocation_id))
    error_message = "nginx_elastic_ip_allocation_id deve ter o formato eipalloc-..."
  }
}