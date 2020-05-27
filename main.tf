provider "google" {
    zone = "europe-west4-a"
}

terraform {
    required_version = "~> 0.12.0"

    backend "remote" {
        hostname = "app.terraform.io"
        organization = "HashiCraft"

        workspaces {
            prefix = "terraform_minecraft_nomad_"
        }
    }
}

resource "google_compute_firewall" "healthcheck" {
    name    = "test-firewall"
    network = "default"

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
    }

    source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
    target_tags = ["allow-healthcheck"]
}

resource "google_compute_health_check" "nomad" {
    name = "nomad"
    check_interval_sec = 5
    timeout_sec = 5
    healthy_threshold = 2
    unhealthy_threshold = 10

    http_health_check {
        request_path = "/v1/agent/health"
        port = "4646"
    }
}

resource "google_compute_http_health_check" "nomad" {
    name = "nomad"
    request_path = "/v1/agent/health"
    port = 4646

    timeout_sec = 5
    check_interval_sec = 5
}

resource "google_storage_bucket" "hashicraft" {
    name          = "hashicraft"
    location      = "EU"
    force_destroy = true
}

resource "google_filestore_instance" "hashicraft" {
    name = "hashicraft"
    tier = "STANDARD"
    zone = "europe-west4-a"

    file_shares {
        capacity_gb = 1024
        name        = "hashicraft"
    }

    networks {
        network = "default"
        modes   = ["MODE_IPV4"]
    }
}