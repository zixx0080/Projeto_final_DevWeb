// Endereço público do servidor Nginx.
output "nginx_public_ip" {
  description = "IP público usado para acessar a aplicação pelo Nginx"
  value       = aws_instance.nginx.public_ip
}

// Endereços públicos das duas instâncias Flask.
output "app_public_ips" {
  description = "IPs públicos das instâncias da aplicação Flask"
  value       = aws_instance.app[*].public_ip
}

// Endereços privados das duas aplicações, usados pelo Nginx.
output "app_private_ips" {
  description = "IPs privados usados pelo Nginx para encaminhar o tráfego"
  value       = aws_instance.app[*].private_ip
}

// IP privado da instância que hospeda o MySQL.
output "db_private_ip" {
  description = "IP privado usado pela aplicação para acessar o MySQL"
  value       = aws_instance.db.private_ip
}

// IDs dos Security Groups criados pela configuração.
output "security_group_ids" {
  description = "IDs dos Security Groups Nginx, App e DB"
  value = {
    nginx = aws_security_group.nginx.id
    app   = aws_security_group.app.id
    db    = aws_security_group.db.id
  }
}