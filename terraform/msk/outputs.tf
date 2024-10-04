output "cluster_arn" {
  value = aws_msk_cluster.kafka_cluster.arn
}

# Output the MSK broker endpoints
output "broker_endpoints" {
  value = aws_msk_cluster.kafka_cluster.bootstrap_brokers
}
