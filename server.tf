#
# Nomad servers.
#
resource "google_compute_target_pool" "server" {
    name = "server"

    health_checks = [
        google_compute_http_health_check.nomad.name,
    ]
}

resource "google_compute_instance_template" "server" {
    name_prefix   = "server-"

    tags = ["nomad", "server", "allow-healthcheck"]

    machine_type = "e2-small"
    can_ip_forward = false

    scheduling {
        automatic_restart = true
        on_host_maintenance = "MIGRATE"
    }

    disk {
        source_image = "hc-da-test/nomad-011"
        auto_delete = true
        boot = true
    }

    metadata_startup_script = data.template_file.server_bootstrap.rendered

    network_interface {
        network = "default"

        access_config {}
    }

    service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    }

    lifecycle {
        create_before_destroy = true
    }
}

data "template_file" "server_bootstrap" {
    template = "${file("${path.module}/resources/server_bootstrap.sh")}"
}

resource "google_compute_instance_group_manager" "server" {
    name = "server"

    base_instance_name = "hashicraft-server"

    version {
        instance_template = google_compute_instance_template.server.self_link
    }

    target_pools = [google_compute_target_pool.server.self_link]
    target_size = 1

    named_port {
        name = "nomad"
        port = 4646
    }

    auto_healing_policies {
        health_check = google_compute_health_check.nomad.self_link
        initial_delay_sec = 300
    }
}