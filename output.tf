output "nomad_ui" {
    value = "http://${google_compute_forwarding_rule.server.ip_address}:${split("-", google_compute_forwarding_rule.server.port_range)[0]}"
}

output "minecraft" {
    value = "${google_compute_forwarding_rule.minecraft-25565.ip_address}:${split("-", google_compute_forwarding_rule.minecraft-25565.port_range)[0]}"
}

output "mumble" {
    value = "${google_compute_forwarding_rule.client.ip_address}:${split("-", google_compute_forwarding_rule.client.port_range)[0]}"
}