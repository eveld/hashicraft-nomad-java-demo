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
}
EOF

systemctl restart nomad