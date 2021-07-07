# FIRST INSTANCE
resource "aws_vpc" "account_one" {
  cidr_block = "10.0.0.0/16"

   tags = {
    Name = "account_one"
  }
}

resource "aws_subnet" "subnet_one" {
  vpc_id            = aws_vpc.account_one.id
  cidr_block        = "10.0.0.0/16"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet_one"
  }
}

resource "aws_network_interface" "network_one" {
  subnet_id   = aws_subnet.subnet_one.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "instance_one" {
  ami           = "ami-005e54dee72cc1d00"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.network_one.id
    device_index         = 0
  }

  tags = {
    Name = "instance_one"
  }
}

# SECOND INSTANCE

resource "aws_vpc" "account_two" {
  cidr_block = "10.101.0.0/16"

   tags = {
    Name = "account_two"
  }
}

resource "aws_subnet" "subnet_two" {
  vpc_id            = aws_vpc.account_two.id
  cidr_block        = "10.101.0.0/16"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet_two"
  }
}


resource "aws_network_interface" "network_two" {
  subnet_id   = aws_subnet.subnet_two.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "secondary_network_interface"
  }
}

resource "aws_instance" "instance_two" {
  ami           = "ami-005e54dee72cc1d00"
  instance_type = "t2.micro"

   network_interface {
    network_interface_id = aws_network_interface.network_two.id
    device_index         = 0
  }

  tags = {
    Name = "instance_two"
  }
}

## VPC Peering
resource "aws_vpc_peering_connection" "foo" {
  peer_owner_id = aws_vpc.account_one.owner_id
  peer_vpc_id   = aws_vpc.account_one.id
  vpc_id        = aws_vpc.account_two.id
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}