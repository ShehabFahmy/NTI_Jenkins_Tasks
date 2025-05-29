resource "aws_security_group" "my-instance-secgrp" {
  vpc_id = aws_vpc.my-vpc.id

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

  tags = {
    Name = "nti-day2-q8-secgrp"
  }
}

# Generate a local RSA key
resource "tls_private_key" "local-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Create key pair in AWS
resource "aws_key_pair" "aws-key-pair" {
  key_name = var.key-pair-name
  public_key = tls_private_key.local-key.public_key_openssh
}

# Save the private key to a file locally (will be destroyed with the key_pair resource)
resource "local_file" "private_key" {
  content  = tls_private_key.local-key.private_key_pem
  filename = "${path.cwd}/${var.key-pair-name}.pem"
}

resource "null_resource" "fix_private_key_permissions" {
  depends_on = [local_file.private_key]

  provisioner "local-exec" {
    command = "chmod 400 \"${local_file.private_key.filename}\""
  }
}
