resource "aws_vpc" "streamforge_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.streamforge_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.streamforge_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

output "vpc_id" {
  value = aws_vpc.streamforge_vpc.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
}
