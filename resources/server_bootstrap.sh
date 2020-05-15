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
cat <<EOF > /etc/nomad.d/server.hcl
log_level = "DEBUG"
data_dir = "/tmp/nomad"

server {
    enabled = true
    bootstrap_expect = 1
}

client {
    enabled = true

    options {
        "docker.auth.config" = "/etc/docker/config.json"
    }
}
EOF

systemctl restart nomad