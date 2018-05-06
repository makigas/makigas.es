#!/usr/bin/env bash

set -e

# THIS IS THE ENTRYPOINT FOR THE WEB APPLICATION DOCKER IMAGE
# THIS FILE IS INTENDED TO BE RUN INSIDE THE DOCKER CONTAINER
# DO NOT JUST RUN THIS SHELL SCRIPT IN A HOST ENVIRONEMNT
# (Nothing bad will happen, but it just won't do anything)

# Remove PID-file if the container was forced to shutdown.
rm -vf tmp/pids/server.pid

# Reinitialize Minio/S3 permissions.
if [ -n "${MINIO_INIT_BUCKET+set}" ]; then
  echo "Setting up Minio bucket policy..."
  bin/rake makigas:minio:init_bucket
fi

# Start the server
exec bin/rails server -b 0.0.0.0
