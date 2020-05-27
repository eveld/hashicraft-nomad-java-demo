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

        volume "world" {
            type      = "host"
            source    = "minecraft_world"
            read_only = false
        }

        volume "config" {
            type      = "host"
            source    = "minecraft_config"
            read_only = false
        }

        task "server" {
            driver = "docker"

            config {
                image = "hashicraft/minecraft:v1.12.2"
            }

            volume_mount {
                volume      = "world"
                destination = "/minecraft/world"
                read_only   = false
            }

            volume_mount {
                volume      = "config"
                destination = "/minecraft/config"
                read_only   = false
            }

            env {
                JAVA_MEMORY="1G",
                MINECRAFT_MOTD="HashiCraft",
                RESOURCE_PACK="https://github.com/HashiCraft/terraform_minecraft_azure_containers/releases/download/files/KawaiiWorld1.12.zip",
                WORLD_BACKUP="https://github.com/HashiCraft/terraform_minecraft_azure_containers/releases/download/files/example_world.tar.gz",
                WHITELIST_ENABLED="true",
                RCON_ENABLED="true",
                RCON_PASSWORD="letmein"
            }

            resources {
                cpu    = 200
                memory = 1500
            }
        }
    }
}