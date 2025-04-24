output "redis_public_ip" {
  description = "Public IP of the Redis server"
  value       = aws_instance.redis_server.public_ip
}
