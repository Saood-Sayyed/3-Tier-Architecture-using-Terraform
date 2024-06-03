resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    name = "vpc1"
  }
}

resource "aws_subnet" "pub_s" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = var.pub_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.az[count.index]
  count = 2

  tags = {
    name = "pub_sub"
  }
}

resource "aws_subnet" "pr_s" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = var.pr_subnet_cidr
  availability_zone = "us-east-1b"

  tags = {
    name = "pr_sub"
  }
}

data "aws_subnet" "sid" {
  filter {
    name = "vpc-id"
    values = [aws_vpc.vpc1.id]
  }
}


resource "aws_security_group" "sg" {

    vpc_id = aws_vpc.vpc1.id
    name = "sg"
  
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
