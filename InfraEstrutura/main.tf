// Localiza a imagem Ubuntu Server mais recente disponível na região.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] // Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// Utiliza a VPC padrão do laboratório AWS Academy.
data "aws_vpc" "default" {
  default = true
}

// Security Group do proxy reverso Nginx.
resource "aws_security_group" "nginx" {
  name        = "nginx-sg-${var.student_name}"
  description = "Permite HTTP publicamente e SSH pelo CIDR autorizado"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Acesso HTTP ao Nginx"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Acesso SSH ao Nginx"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    description = "Permite trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-sg-${var.student_name}"
  }
}

// Security Group das duas instâncias Flask.
resource "aws_security_group" "app" {
  name        = "app-sg-${var.student_name}"
  description = "Permite Flask somente pelo Nginx e SSH pelo CIDR autorizado"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "Flask acessivel somente pelo Security Group do Nginx"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx.id]
  }

  ingress {
    description = "Acesso SSH as instancias Flask"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    description = "Permite trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg-${var.student_name}"
  }
}

// Security Group do banco MySQL.
resource "aws_security_group" "db" {
  name        = "db-sg-${var.student_name}"
  description = "Permite MySQL somente a partir das instancias Flask"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "MySQL acessivel somente pelas instancias Flask"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  ingress {
    description     = "Acesso SSH a instancia MySQL somente pelas instancias Flask"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    description = "Permite trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg-${var.student_name}"
  }
}

// Instância pública responsável pelo Nginx e pelo proxy reverso.
resource "aws_instance" "nginx" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.nginx.id]
  associate_public_ip_address = true

  tags = {
    Name = var.nginx_name
    Role = "nginx"
  }
}

// Mantém o Elastic IP associado à instância do Nginx.
resource "aws_eip_association" "nginx" {
  instance_id   = aws_instance.nginx.id
  allocation_id = var.nginx_elastic_ip_allocation_id
}

// Duas instâncias Flask. O índice 0 cria app1 e o índice 1 cria app2.
resource "aws_instance" "app" {
  count                       = var.app_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true

  tags = {
    Name = var.app_names[count.index]
    Role = "flask-app"
  }
}

// Instância do banco de dados MySQL.
resource "aws_instance" "db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.db.id]
  // A subnet padrão atribui IP público; o Security Group limita o acesso.
  associate_public_ip_address = true

  tags = {
    Name = var.db_name
    Role = "mysql-db"
  }
}