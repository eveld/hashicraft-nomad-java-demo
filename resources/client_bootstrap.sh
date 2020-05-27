#!/bin/bash
IP=$(getent ahosts $HOSTNAME | head -n 1 | cut -d ' ' -f 1)

# Set up credential helpers for Google Container Registry.
mkdir -p /etc/docker
cat <<EOF > /etc/docker/config.json
{
  "credHelpers": {
    "gcr.io": "gcr"
  }
}
EOF

# Configure Nomad.
mkdir -p /etc/nomad.d
cat <<EOF > /etc/nomad.d/client.hcl
log_level = "DEBUG"
data_dir = "/tmp/nomad"

client {
    enabled = true

    options {
        "docker.auth.config" = "/etc/docker/config.json"
    }

    server_join {
        retry_join = ["provider=gce zone_pattern=europe-west4-a tag_value=server"]
        retry_interval = "15s"
    }

    host_volume "minecraft_world" {
        path      = "/mnt/minecraft/world"
        read_only = false
    }

    host_volume "minecraft_config" {
        path      = "/mnt/minecraft/config"
        read_only = false
    }
}
EOF

# NFS
apt-get update && apt-get install -y nfs-common
mkdir -p /mnt/minecraft/world
mkdir -p /mnt/minecraft/config
echo "${filestore_instance}:/hashicraft /mnt/minecraft nfs defaults 0 0" >> /etc/fstab
mount -a

systemctl restart nomad