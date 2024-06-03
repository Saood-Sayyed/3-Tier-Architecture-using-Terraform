variable "pub_subnet_cidr" {
  type = list
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "pr_subnet_cidr" {
  default = "10.0.3.0/24"
}


variable "az" {
  type = list
  default = ["us-east-1a","us-east-1b"]
}

