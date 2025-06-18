variable "do_token"     { type = string }
variable "ssh_key_name" { type = string }

variable "droplet_name"   { type = string default = "axialy-site" }
variable "region"         { type = string default = "nyc3" }
variable "image"          { type = string default = "ubuntu-22-04-x64" }
variable "size"           { type = string default = "s-1vcpu-1gb" }
variable "enable_backups" { type = bool   default = false }
variable "tags"           { type = list(string) default = [] }
