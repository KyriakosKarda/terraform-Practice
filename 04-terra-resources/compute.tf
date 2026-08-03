resource "aws_instance" "web" {
  ami                         = "ami-06e78a71af43ef21a" //https://cloud-images.ubuntu.com/locator/ec2/
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.public_traffic.id]
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  user_data = <<-EOF
                #!/bin/bash
                apt-get update -y
                apt-get install -y nginx
                systemctl enable nginx
                systemctl start nginx
                EOF

  tags = merge(local.common_tags, {
    Name = "Ec2-instance"
  })


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "public_traffic" {
  description = "Allow HTTP requests at port 443 and 80"
  name        = "public-http-traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = merge(local.common_tags, {
    Name = "SG-for-EC2"
  })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "80"
  to_port           = "80"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.public_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "443"
  to_port           = "443"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.public_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "22"
  to_port           = "22"
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "traffic_to_internet" {
  security_group_id = aws_security_group.public_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

