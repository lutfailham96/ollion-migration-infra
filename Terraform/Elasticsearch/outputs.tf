output "es_public_ips" {
  value = aws_instance.es_node[*].public_ip
}

output "es_private_ips" {
  value = aws_instance.es_node[*].private_ip
}
