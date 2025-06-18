data "digitalocean_ssh_key" "deployer" {
  name = var.ssh_key_name
}

resource "digitalocean_droplet" "web" {
  name     = "${var.name_prefix}-droplet"
  image    = "ubuntu-22-04-x64"
  region   = var.region
  size     = var.size
  ssh_keys = [data.digitalocean_ssh_key.deployer.id]
  tags     = ["web"]
}

output "droplet_ip" {
  description = "Public IPv4 address of the droplet"
  value       = digitalocean_droplet.web.ipv4_address
}
