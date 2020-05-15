job "teamspeak" {
    datacenters = ["dc1"]

    type = "service"

    group "teamspeak" {
        count = 1

        network {
            mode = "bridge"

            port "voice" {
                to = 9987
                static = 9987
            }

            port "query" {
                to = 10011
            }

            port "file" {
                to = 30033
            }
        }

        task "server" {
            env {
                TS3SERVER_LICENSE = "accept"
            }

            driver = "docker"

            config {
                image = "teamspeak:3.12.1"
            }

            resources {
                cpu    = 100
                memory = 256
            }
        }
    }
}