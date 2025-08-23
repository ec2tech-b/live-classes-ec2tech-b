#count , for_each

resource "null_resource" "test" {
  count = 10
}

resource "null_resource" "test1" {
  for_each = var.colors-codes
}

variable "colors-codes" {
  default = {
    red     = 31
    green   = 32
    yellow  = 33
    blue    = 34
    magenta = 35
    cyan    = 36

  }
}