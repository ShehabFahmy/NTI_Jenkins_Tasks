resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = "nti-day2-q8-vpc"
  }
}

resource "aws_subnet" "my-subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = var.subnet-cidr[1]
  # map_public_ip_on_launch = true

  tags = {
    Name = var.subnet-cidr[0]
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  
  tags = {
    Name = "nti-day2-q8-igw"
  }
}

resource "aws_route_table" "my-rtb" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  
  tags = {
    Name = "nti-day2-q8-rtb"
  }
}

resource "aws_route_table_association" "my-rtb-assoc" {
  subnet_id = aws_subnet.my-subnet.id
  route_table_id = aws_route_table.my-rtb.id
}

resource "aws_instance" "aws-linux-instance" {
  ami = var.aws-linux-instance-ami
  instance_type = var.instance-type
  key_name = aws_key_pair.aws-key-pair.key_name
  subnet_id = aws_subnet.my-subnet.id
  vpc_security_group_ids = [aws_security_group.my-instance-secgrp.id]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              useradd -m -s /bin/bash ansibleadmin
              echo "ansibleadmin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansibleadmin
              chmod 440 /etc/sudoers.d/ansibleadmin
              mkdir -p /home/ansibleadmin/.ssh
              echo "${tls_private_key.local-key.public_key_openssh}" > /home/ansibleadmin/.ssh/authorized_keys
              chmod 600 /home/ansibleadmin/.ssh/authorized_keys
              chown -R ansibleadmin:ansibleadmin /home/ansibleadmin/.ssh
              EOF

  tags = {
    Name = "my-ec2"
  }
}
