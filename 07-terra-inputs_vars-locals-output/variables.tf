variable "ec2_instance_type" {
  type        = string
  default     = "t4.micro"
  description = "Size of the EC2 instance"
  validation {
    condition     = var.ec2_instance_type == "t2.micro" || var.ec2_instance_type == "t3.micro"
    error_message = "t2.micro or t3.micro is SUPPORTED!!!"
  }
}

variable "ec2_volume_size" {
  type        = number
  description = "Size of the root volume in GB"
}

variable "ec2_volume_type" {
  type        = string
  description = "volume type gp2/gp3"
}