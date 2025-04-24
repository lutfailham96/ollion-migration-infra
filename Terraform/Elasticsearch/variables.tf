variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "public_key_path" {
  description = "Path to your public SSH key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_count" {
  default = 3
}

variable "instance_type" {
  default = "t3.medium"
}
