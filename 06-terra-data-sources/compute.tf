resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }
    lifecycle {
      create_before_destroy = true
    }
}