variable "instances" {
  default = {
    "web"    = "t3.micro"
    "db"     = "t3.medium"
    "worker" = "t3.small"
  }
}

resource "aws_instance" "example" {
  for_each     = var.instances
  ami          = "ami-0533f2ba8a1995cf9"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}