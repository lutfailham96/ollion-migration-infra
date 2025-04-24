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

resource "aws_instance" "es_node" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.default.key_name
  security_groups = [aws_security_group.es_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y openjdk-11-jdk wget apt-transport-https gnupg curl

              wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
              echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-8.x.list
              apt update
              apt install -y elasticsearch

              NODE_NAME="es-node-${count.index + 1}"
              cat <<EOT > /etc/elasticsearch/elasticsearch.yml
              cluster.name: es-cluster
              node.name: $NODE_NAME
              network.host: 0.0.0.0
              discovery.seed_hosts: [${join(",", aws_instance.es_node[*].private_ip)}]
              cluster.initial_master_nodes: ["es-node-1","es-node-2","es-node-
