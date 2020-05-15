job "minecraft" {
    datacenters = ["dc1"]

    type = "service"

    group "minecraft" {
        count = 1

        network {
            mode = "bridge"

            port "minecraft" {
                to = 25565
                static = 25565
            }

            port "rcon" {
                to = 27015
            }
        }

        task "server" {
            template {
                data = <<EOF
eula=true
EOF
                destination = "eula.txt"
            }

            artifact {
                // source = "https://launcher.mojang.com/v1/objects/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar"
                source = "https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"
            }

            driver = "java"

            config {
                jar_path    = "local/server.jar"
                jvm_options = ["-Xmx2048m", "-Xms256m"]
                args = ["nogui"]
            }

            resources {
                cpu    = 100
                memory = 2048
            }
        }
    }
}