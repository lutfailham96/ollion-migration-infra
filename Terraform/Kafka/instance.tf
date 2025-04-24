data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "kafka_node" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  key_name      = aws_key_pair.default.key_name
  security_groups = [aws_security_group.kafka_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y default-jdk wget net-tools

              # Install Kafka
              wget https://downloads.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz
              tar -xzf kafka_2.13-3.7.0.tgz
              mv kafka_2.13-3.7.0 /opt/kafka

              # Basic Zookeeper config
              echo "tickTime=2000" > /opt/kafka/config/zookeeper.properties
              echo "dataDir=/tmp/zookeeper" >> /opt/kafka/config/zookeeper.properties
              echo "clientPort=2181" >> /opt/kafka/config/zookeeper.properties
              echo "initLimit=5" >> /opt/kafka/config/zookeeper.properties
              echo "syncLimit=2" >> /opt/kafka/config/zookeeper.properties

              # Start Zookeeper
              nohup /opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties > /tmp/zookeeper.log 2>&1 &

              sleep 10

              # Basic Kafka config
              BROKER_ID=$((${count.index} + 1))
              echo "broker.id=$BROKER_ID" > /opt/kafka/config/server.properties
              echo "log.dirs=/tmp/kafka-logs" >> /opt/kafka/config/server.properties
              echo "zookeeper.connect=localhost:2181" >> /opt/kafka/config/server.properties
              echo "listeners=PLAINTEXT://0.0.0.0:9092" >> /opt/kafka/config/server.properties
              echo "auto.create.topics.enable=true" >> /opt/kafka/config/server.properties

              # Start Kafka
              nohup /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties > /tmp/kafka.log 2>&1 &
              EOF

  tags = {
    Name = "kafka-node-${count.index + 1}"
  }
}
