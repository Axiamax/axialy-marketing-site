terraform {
  required_version = ">= 1.5.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.33.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "default" {
  name = var.ssh_key_name
}

resource "digitalocean_droplet" "web" {
  name    = "${var.droplet_name}-${terraform.workspace}"
  region  = var.region
  image   = var.image
  size    = var.size
  backups = var.enable_backups

  ssh_keys = [data.digitalocean_ssh_key.default.id]
  tags     = concat(var.tags, ["axialy-web"])
}

output "droplet_ip" {
  value = digitalocean_droplet.web.ipv4_address
}
