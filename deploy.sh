#!/bin/bash
set -e

# optionally export DOCKERHUB credentials if needed, or rely on public images
# docker login -u "$DOCKERHUB_USER" -p "$DOCKERHUB_PASS"

# path where docker-compose.yml is
DEPLOY_DIR=~/deploy/Devops-Internship-Assingment
cd "$DEPLOY_DIR"

# pull latest images and recreate containers
docker compose pull
docker compose up -d --remove-orphans --force-recreate

# show status
docker compose pis
