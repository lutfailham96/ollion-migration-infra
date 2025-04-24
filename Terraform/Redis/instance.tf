resource "aws_instance" "redis_server" {
  ami           = "ami-0fa7491d9837dba9c" # Ubuntu 22.04 in Jakarta
  instance_type = "t3.micro"
  key_name      = aws_key_pair.default.key_name
  security_groups = [aws_security_group.redis_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y redis-server
              sed -i 's/^supervised no/supervised systemd/' /etc/redis/redis.conf
              sed -i 's/^bind 127.0.0.1 -::1/#bind 127.0.0.1 -::1/' /etc/redis/redis.conf
              sed -i 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf
              systemctl restart redis.service
              systemctl enable redis.service
              EOF

  tags = {
    Name = "redis-server"
  }
}
