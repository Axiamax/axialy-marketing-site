variable "do_token" {
  description = "DigitalOcean API token."
  type        = string
  sensitive   = true
}

variable "ssh_key_name" {
  description = "Name of your SSH public key in DigitalOcean."
  type        = string
}

variable "region" {
  description = "DigitalOcean region."
  type        = string
  default     = "sfo3"
}

variable "size" {
  description = "Droplet size slug."
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "name_prefix" {
  description = "Prefix for naming resources."
  type        = string
  default     = "axialy"
}
