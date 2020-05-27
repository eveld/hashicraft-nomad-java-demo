#
# Servers
#
resource "google_compute_address" "server" {
  name = "nomad-server"
}

resource "google_compute_forwarding_rule" "server" {
    name       = "server-4646"
    target     = google_compute_target_pool.server.id
    port_range = "4646"
    ip_address = google_compute_address.server.address
}

resource "google_compute_firewall" "server-4646" {
    name = "server-4646"
    network = "default"

    allow {
        protocol = "tcp"
        ports    = ["4646"]
    }

    allow {
        protocol = "udp"
        ports    = ["4646"]
    }

    source_ranges = ["213.127.31.235/32", "82.42.181.161/32"]
    target_tags = ["nomad", "server"]
}

#
# Clients
#
resource "google_compute_address" "client" {
  name = "nomad-client"
}

resource "google_compute_forwarding_rule" "client" {
    name       = "client-64738"
    target     = google_compute_target_pool.client.id
    port_range = "64738"
    ip_address = google_compute_address.client.address
}

resource "google_compute_firewall" "client-64738" {
    name = "client-64738"
    network = "default"

    allow {
        protocol = "tcp"
        ports    = ["64738"]
    }

    allow {
        protocol = "udp"
        ports    = ["64738"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["nomad", "client"]
}

resource "google_compute_forwarding_rule" "minecraft-25565" {
    name       = "minecraft-25565"
    target     = google_compute_target_pool.client.id
    port_range = "25565"
    ip_address = google_compute_address.client.address
}

resource "google_compute_firewall" "minecraft-25565" {
    name = "minecraft-25565"
    network = "default"

    allow {
        protocol = "tcp"
        ports    = ["25565"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["nomad", "client"]
}