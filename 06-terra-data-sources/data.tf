data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*" ]

  }
}

output "ubuntu_image_id" {
  value = data.aws_ami.ubuntu.id
}


output "ubuntu_image_arn" {
  value = data.aws_ami.ubuntu.arn
}