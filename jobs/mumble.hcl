job "mumble" {
    datacenters = ["dc1"]

    type = "service"

    group "mumble" {
        count = 1

        network {
            mode = "bridge"

            port "voice" {
                to = 64738
                static = 64738
            }
        }

        task "server" {
            artifact {
                source = "https://github.com/mumble-voip/mumble/releases/download/1.3.0/murmur-static_x86-1.3.0.tar.bz2"
            }

            driver = "exec"

            config {
                command = "local/murmur-static_x86-1.3.0/murmur.x86"
                args = ["-fg", "-v"]
            }

            resources {
                cpu    = 200
                memory = 256
            }
        }
    }
}