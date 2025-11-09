Dias Stack Environment Overview

This document outlines the complete development and deployment architecture for the Dias stack, including the Linux server configuration, the GitHub repository setup, and the automated CI/CD pipeline.

1. System Architecture

The entire system is designed around a CI/CD pipeline that automatically builds, containerizes, and deploys applications from GitHub to a private Ubuntu server.

The high-level data flow is as follows:

Local Development: A developer (on Windows) pushes a code change to one of the 4 application repositories (e.g., larstrustworks/DiasRestApi).

Build & Push (GitHub): A GitHub Actions workflow (build-and-deploy.yml) in the application repo triggers. It builds a fresh Docker image and pushes it to the GitHub Container Registry (GHCR) (e.g., ghcr.io/larstrustworks/dias-rest-api:latest).

Trigger Deploy (GitHub): After the image is pushed, the same workflow uses a Personal Access Token (WORKFLOW_PAT) to send an API request to the central dias-stack-deployment repository, triggering its "Deploy" workflow.

Receive & Deploy (Linux Server):

The dias-stack-deployment repo has a self-hosted GitHub Runner installed on the Ubuntu server.

The "Deploy" workflow (deploy.yml) begins running on the server.

The runner checks out the docker-compose.yml from the repo, cds to the stack's home directory (to access the .env file), and runs docker compose pull and docker compose up -d.

Live Server: Docker Compose pulls the newly-built image from GHCR and gracefully restarts only the container that was updated.

2. Linux Server Configuration

The production environment runs on a single Ubuntu server, containerized with Docker.

Host: Ubuntu 24.04.2 LTS

Core Software: Docker Engine & Docker Compose plugin

Project Home Directory: /home/your-user/dias-stack

This directory contains the master .env file and a local clone of the dias-stack-deployment repo.

Secrets & Configuration (.env)

All secrets (database passwords, API keys, etc.) are stored only on the server in a single file. This file is not in Git.

File Location: /home/your-user/dias-stack/.env

Purpose: This file is automatically read by docker compose when the deployment script runs.

Key Variables:

DB_HOST: IP address of the Windows SQL Server

DB_USER: Database username

DB_PASSWORD: Database password

DB_NAME: Database name

JWT_SECRET_KEY: Long, random string for signing JWT tokens

JWT_ISSUER / JWT_AUDIENCE: JWT validation strings

IMAGE_TAG: Defines which image tag to pull (e.g., latest)

IMAGE_REGISTRY_PATH: ghcr.io/larstrustworks

GitHub Actions Runner

A self-hosted GitHub Actions runner is the critical link between GitHub and the server.

Install Directory: $HOME/actions-runner

Registration: The runner is registered only to the larstrustworks/dias-stack-deployment repository.

Permissions: It runs as a systemd service, allowing it to execute docker commands on the host.

3. GitHub & CI/CD Setup

The entire project is managed under the larstrustworks personal account.

Repository Structure

The project is split into 6 repositories for a clean separation of concerns.

Repository

Purpose

Local Path (Windows)

dias-combine-repo

Parent repo for local dev. Contains this README and a .gitignore to ignore the other repos.

C:\Users\A246428\dias

dias-stack-deployment

(Central Hub) Holds the "Deploy" workflow and the master docker-compose.yml. The server's runner is tied to this repo.

...\dias\dias-stack-deployment

DiasRestApi

Application code, Dockerfile, and "Build & Trigger" workflow for the .NET REST API.

...\dias\DiasRestApi

DiasDalApi

Application code, Dockerfile, and "Build & Trigger" workflow for the .NET DAL API.

...\dias\DiasDalApi

DiasAdminUi

Application code, Dockerfile, and "Build & Trigger" workflow for the React/Express Admin UI.

...\dias\DiasAdminUi

dias-edu-hub

Application code, Dockerfile, and "Build & Trigger" workflow for the React/Express EduHub.

...\dias\dias-edu-hub

Authentication

Windows PC -> GitHub: Uses HTTPS + Personal Access Token (PAT), cached by the Windows Credential Manager.

Ubuntu Server -> GitHub: Uses HTTPS + PAT (cached via git config --global credential.helper store) for any manual git pull operations in the stack directory.

CI/CD (Build -> Deploy): The 4 app repos use a repository secret named WORKFLOW_PAT (which holds a PAT) to gain permission to trigger the deploy.yml workflow in the dias-stack-deployment repo.

CI/CD Workflow Files

1. "Build & Trigger" Workflow

Location: .github/workflows/build-and-deploy.yml (in all 4 app repos)

Trigger: push to dev (or main) branch.

Runs On: ubuntu-latest (GitHub's cloud runners)

Jobs:

build-and-push: Logs into GHCR, builds the Dockerfile from the repo, and pushes the image to ghcr.io/larstrustworks/<image-name>:latest.

trigger-deployment: Uses the WORKFLOW_PAT secret to send a workflow_dispatch event to larstrustworks/dias-stack-deployment.

2. "Deploy" Workflow

Location: .github/workflows/deploy.yml (in the dias-stack-deployment repo)

Trigger: on: workflow_dispatch (listens for the API call from the app repos)

Runs On: self-hosted (Your Ubuntu server)

Jobs:

deploy: Logs into GHCR, cds to /home/your-user/dias-stack (to access the .env), checks out the docker-compose.yml from the repo, and executes docker compose ... pull and docker compose ... up -d.