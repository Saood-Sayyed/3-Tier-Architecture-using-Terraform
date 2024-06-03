variable "sg" {
  type        = list(string)
}

variable "s1" {
  type        = list(string)
}


variable "pr_sub" {
  
}

variable "private_key_content" {
  description = "Content of the private key file"
  type        = string
  sensitive   = true
}