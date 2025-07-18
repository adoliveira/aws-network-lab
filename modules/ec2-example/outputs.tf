output "public_instance_ids" {
  description = "IDs das instâncias EC2 públicas"
  value       = aws_instance.public[*].id
}

output "private_instance_ids" {
  description = "IDs das instâncias EC2 privadas"
  value       = aws_instance.private[*].id
}

output "public_instance_public_ips" {
  description = "IPs públicos das instâncias públicas"
  value       = aws_instance.public[*].public_ip
}

output "public_instance_private_ips" {
  description = "IPs privados das instâncias públicas"
  value       = aws_instance.public[*].private_ip
}

output "private_instance_private_ips" {
  description = "IPs privados das instâncias privadas"
  value       = aws_instance.private[*].private_ip
}

output "public_security_group_id" {
  description = "ID do security group das instâncias públicas"
  value       = aws_security_group.public_instance.id
}

output "private_security_group_id" {
  description = "ID do security group das instâncias privadas"
  value       = aws_security_group.private_instance.id
}
