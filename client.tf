#
# Nomad clients.
#
resource "google_compute_target_pool" "client" {
    name = "client"

    health_checks = [
        google_compute_http_health_check.nomad.name,
    ]
}

resource "google_compute_instance_template" "client" {
    name_prefix   = "client-"

    tags = ["nomad", "client", "allow-healthcheck"]

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

    metadata_startup_script = data.template_file.client_bootstrap.rendered

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

data "template_file" "client_bootstrap" {
    template = "${file("${path.module}/resources/client_bootstrap.sh")}"
    vars = {
        filestore_instance = google_filestore_instance.hashicraft.networks[0].ip_addresses[0]
    }
}

resource "google_compute_instance_group_manager" "client" {
    name = "client"

    base_instance_name = "hashicraft-client"

    version {
        instance_template = google_compute_instance_template.client.self_link
    }

    target_pools = [google_compute_target_pool.client.self_link]
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