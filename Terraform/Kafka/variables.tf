variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "public_key_path" {
  description = "Path to public SSH key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_count" {
  type    = number
  default = 3
}
