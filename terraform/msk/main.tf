resource "random_string" "random" {
  length           = 16
  special          = false
  upper            = false
}

resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "streamforge-msk-cluster-${random_string.random.result}"
  kafka_version          = "3.5.1"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = var.private_subnet_ids
    security_groups = [var.security_group_id]
  }
}
