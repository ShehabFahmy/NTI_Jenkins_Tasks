variable "region" {
  type = string
  default = "us-east-1"
}

variable "vpc-cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "subnet-cidr" {
  type    = tuple([string, string])
  default = ["nti-day2-q8-pb-subnet", "10.0.1.0/24"]
}

variable "aws-linux-instance-ami" {
  type = string
  default = "ami-084568db4383264d4"
}

variable "instance-type" {
  type = string
  default = "t2.micro"
}

variable "ansible-inventory-file-name" {
  type = string
  default = "inventory.ini"
}

variable "ansible-cfg-file-name" {
  type = string
  default = "ansible.cfg"
}

variable "key-pair-name" {
  type = string
  default = "nti-day2-q8-key"
}
