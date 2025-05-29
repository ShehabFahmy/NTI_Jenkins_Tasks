output "public-ip" {
  value = aws_instance.aws-linux-instance.public_ip
}

resource "local_file" "ansible-inventory-file-creation" {
  content  = "[all:vars]\nansible_user = ansibleadmin\n[servers]\nmy-ec2 ansible_host=${aws_instance.aws-linux-instance.public_ip}"
  filename = "${path.cwd}/${var.ansible-inventory-file-name}"
}

resource "local_file" "ansible-cfg-file-creation" {
  content  = "[defaults]\ninventory = ${var.ansible-inventory-file-name}\nprivate_key_file = ${aws_key_pair.aws-key-pair.key_name}.pem\nhost_key_checking = False"
  filename = "${path.cwd}/${var.ansible-cfg-file-name}"
}
