resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
  
}

resource "aws_subnet" "sn_01" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.sn_01_cidr
     
}

resource "aws_subnet" "sn_02" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.sn_02_cidr

}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = var.rt_cidr
        gateway_id =  aws_internet_gateway.IGW.id
    }
  
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.my_vpc.id
  
}

resource "aws_route_table_association" "public_RT" {
    subnet_id = aws_subnet.sn_01.id
    route_table_id = aws_route_table.RT.id

}

locals {
  ingress = var.ingress

}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  #description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = local.ingress
    content {
    description = "TLS from VPC"
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = [var.allow_tls]
      
    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "ec2" {
    ami                         = var.ami_id
    instance_type               = var.instance_type
    subnet_id                   = aws_subnet.sn_01.id
    vpc_security_group_ids      = [aws_security_group.allow_tls.id]
    key_name = var.key_name
    associate_public_ip_address = true

  
}