resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "streamforge-msk-cluster-${random_string.random.result}"
  kafka_version          = "3.5.1"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = var.private_subnet_ids
    security_groups = [aws_security_group.msk_sg.id]
  }
}

resource "aws_security_group" "msk_sg" {
  vpc_id = var.vpc_id # Use the input variable for VPC ID

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
