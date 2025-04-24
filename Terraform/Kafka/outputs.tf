output "kafka_node_ips" {
  description = "Public IPs of Kafka nodes"
  value       = aws_instance.kafka_node[*].public_ip
}
