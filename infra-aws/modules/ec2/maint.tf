resource "aws_security_group" "instance_sg" {
name = "instance-sg-${var.environment}"
vpc_id = var.vpc_id
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
}


resource "aws_instance" "web" {
ami = data.aws_ami.ubuntu.id
instance_type = "t3.micro"
subnet_id = var.subnet_ids[0]
security_groups = [aws_security_group.instance_sg.id]
tags = { Name = "ec2-${var.environment}" }
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}


output "ec2_public_ip" { value = aws_instance.web.public_ip }