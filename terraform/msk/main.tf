resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}

# VPC and Subnet Configuration
resource "aws_vpc" "msk_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "msk_igw" {
  vpc_id = aws_vpc.msk_vpc.id
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.msk_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-1a"
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id     = aws_vpc.msk_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-1b"
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.msk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.msk_igw.id
  }
}

resource "aws_route_table_association" "public_association_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_association_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group for Public Access
resource "aws_security_group" "msk_security_group" {
  vpc_id = aws_vpc.msk_vpc.id
  name   = "msk-public-access-sg"

  # Allow Kafka clients to connect via public IPs
  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access if needed for troubleshooting (optional)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "streamforge-msk-cluster-${random_string.random.result}"
  kafka_version          = "3.5.1"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
    security_groups = [aws_security_group.msk_security_group.id]
  }

   encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT" # No encryption for public accessibility
      in_cluster    = true
    }
  }

  enhanced_monitoring = "PER_BROKER"
}
