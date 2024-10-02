resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "streamforge-msk-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = var.private_subnet_ids
    security_groups = [var.security_group_id]
  }
}
