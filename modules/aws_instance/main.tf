data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_security_group" "this" {
  name   = "${var.identifier}-instance"
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}-instance"
  }
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ingress_icmp" {
  cidr_blocks = [
    "10.0.0.0/8"
  ]
  from_port         = -1
  protocol          = "icmp"
  security_group_id = aws_security_group.this.id
  to_port           = -1
  type              = "ingress"
}

resource "aws_security_group_rule" "ingress_ssh" {
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.bastion_security_group_id 
  to_port                  = 22
  type                     = "ingress"
}

resource "aws_security_group_rule" "egress" {
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.this.id
  to_port           = 0
  type              = "egress"
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [
    aws_security_group.this.id
  ]
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}-instance"
  }
}
