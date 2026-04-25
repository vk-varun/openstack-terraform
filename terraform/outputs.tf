output "controller_ips" {
  value = google_compute_instance.controller[*].network_interface[0].network_ip
}

output "compute_ips" {
  value = google_compute_instance.compute[*].network_interface[0].network_ip
}

output "network_ips" {
  value = google_compute_instance.network[*].network_interface[0].network_ip
}

output "storage_ips" {
  value = google_compute_instance.storage[*].network_interface[0].network_ip
}

output "controller_public_ips" {
  value = google_compute_instance.controller[*].network_interface[0].access_config[0].nat_ip
}

output "compute_public_ips" {
  value = google_compute_instance.compute[*].network_interface[0].access_config[0].nat_ip
}

output "vip_ip" {
  value = var.vip_ip
}

output "ansible_inventory" {
  value = templatefile("${path.module}/inventory.tpl", {
    controllers = google_compute_instance.controller[*].network_interface[0].network_ip
    computes    = google_compute_instance.compute[*].network_interface[0].network_ip
    networks    = google_compute_instance.network[*].network_interface[0].network_ip
    storages    = google_compute_instance.storage[*].network_interface[0].network_ip
  })
}
