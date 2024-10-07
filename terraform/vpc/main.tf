resource "aws_vpc" "streamforge_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.streamforge_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-1a"
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.streamforge_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-1b"
}
