#int, list , map , bool , string
#var.variablename -- referencing a variable


variable "x" {
    default = 10
}

variable "y_list" {
   default = ["abc","cad",7]
}

variable "z_map" {
   default = {
    x = 10
    y = 20
   }
}

variable "env" {}

output "env" {
    value = var.env
}



output "x" {
    value = var.x
}

output "y" {
    value = var.y_list
} 

output "y_1" {
    value = var.y_list[1]
} 

output "z_x" {
    value = var.z_map["x"]
}

variable "Name" {}

output "Name" {
    value = var.Name
}





# 1. var.tf
# 2. *.tfvars
# 3. *.auto.tfvars