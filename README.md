
# MEAN Stack Application Deployment

This repository contains a full-stack **MEAN (MongoDB, Express, Angular, Node.js) application** deployed using **Docker, Docker Compose, and Nginx**. The deployment is designed to run on an **Ubuntu EC2 instance**.

---

## Folder Structure

deploy/
├── frontend/ # Angular frontend code
├── backend/ # Node.js & Express backend code
├── nginx/ # Nginx configuration
│ └── nginx.conf
├── docker-compose.yml # Docker Compose setup
├── deploy.sh # Script to update & deploy containers
└── README.md # Project documentation

## Prerequisites

- Ubuntu server (EC2 or any VM)
- Docker installed
- Docker Compose installed
- Internet access to pull Docker images
- Git installed to pull the repository

## Deployment Steps

### 1. Clone the Repository
git clone https://github.com/<your-username>/crud-dd-mean-app.git
cd crud-dd-mean-app
2. Configure Deployment Script
deploy.sh automates deployment:
#!/bin/bash
git pull origin main
docker compose pull
docker compose up -d
Make it executable:
chmod +x deploy.sh
3. Deploy the Application
Run the deploy script:
./deploy.sh
This will:

Pull the latest code from GitHub

Pull updated Docker images from Docker Hub

Start all containers (MongoDB, Backend, Frontend, Nginx)

4. Verify Deployment
Frontend: Open your browser at:
http://3.109.32.156
Backend API: Test with curl:
curl http://localhost:3000
Expected output:
{"message":"Welcome to Test application."}
Check logs:
docker logs deploy-backend-1
docker logs deploy-frontend-1
docker logs deploy-nginx-1
docker logs deploy-mongo-1
Docker Compose Overview
version: "3.8"

services:
  mongo:
    image: mongo:latest
    container_name: deploy-mongo-1
    ports:
      - "27017:27017"
    restart: always

  backend:
    image: sarwanragul/crud-mean-backend:latest
    container_name: deploy-backend-1
    ports:
      - "3000:8080"
    depends_on:
      - mongo
    restart: always

  frontend:
    image: sarwanragul/crud-mean-frontend:latest
    container_name: deploy-frontend-1
    ports:
      - "80:80"
    depends_on:
      - backend
    restart: always

  nginx:
    image: nginx:latest
    container_name: deploy-nginx-1
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - frontend
      - backend
    restart: always
Nginx Configuration
nginx/nginx.conf:
nginx
server {
    listen 80;

    location / {
        proxy_pass http://deploy-frontend-1:80;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    location /api/ {
        proxy_pass http://deploy-backend-1:8080/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
CI/CD Workflow
A GitHub Actions workflow is added in .github/workflows/deploy.yml

Automates:

Building backend & frontend Docker images

Pushing images to Docker Hub
