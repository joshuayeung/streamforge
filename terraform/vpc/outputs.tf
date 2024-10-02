
output "vpc_id" {
  value = aws_vpc.streamforge_vpc.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
}
