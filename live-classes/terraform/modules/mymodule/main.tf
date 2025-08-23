resource "aws_instance" "test" {
  ami           = "ami-0533f2ba8a1995cf9"
  instance_type = var.instance_type

  tags = {
    Name = var.Name
    terraform = var.terraform
  }
}

