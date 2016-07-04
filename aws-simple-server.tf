# How to run:
# create ~/.ssh.id_rsa{,.pub} with ssh-keygen
# create ~/.aws/credentials; see AWS IAM docs; don't use master keys for account, use keys for an IAM user which is assigned to an IAM group which has a policy to do these actions.
# $ TF_VAR_public_server_ssh_public_key=`cat ~/.ssh/id_rsa.pub` terraform plan
#   --> to create/update infrastructure, run exact same command with "apply" instead of "plan"
# $ ssh ubuntu@<elastic ip>  // ubuntu is default user for an ubuntu-based ami

provider "aws" {
  region     = "us-east-1"
}

variable "public_server_ssh_public_key" {}

resource "aws_key_pair" "public_server" {
  key_name = "public_server"
  public_key = "${var.public_server_ssh_public_key}"
}

resource "aws_security_group" "public_server" {
  name = "public_server"
  description = "Allow public inbound icmp echo request, ssh; allow all outbound"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 8 # Note this isn't port 8, it's icmp type 8, see terraform docs
      to_port = 0 # to_port isn't used for icmp
      protocol = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "public_server"
  }
}

resource "aws_instance" "public_server" {
  ami           = "ami-ddf13fb0"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.public_server.id}"]
  key_name = "${aws_key_pair.public_server.key_name}"
}

resource "aws_eip" "public_server" {
  instance = "${aws_instance.public_server.id}"
  vpc      = false
}

output "public_server_elastic_ip" {
    value = "${aws_eip.public_server.public_ip}"
}

output "public_server_ssh_public_key" {
  value = "${public_server_ssh_public_key}"
}
