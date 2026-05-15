#variable "ssh_public_key" {
  #description = "Публичный SSH-ключ для доступа к ВМ"
  #type        = string
  #sensitive   = true
  #default     = ""
#}

variable "username" {
  description = "SSH username"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}