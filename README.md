## ✅ Overview

This repository contains solutions for the DevOps Engineer Skills Assessment.

- **Task 1:** Provision infrastructure using Terraform modules (VPC, RDS, S3, EKS)
- **Task 2:** Containerize a Node.js application and implement CI/CD with GitHub Actions
- **Task 3:** Monitoring & Automation: include a Python script for URL health checks and Slack/email alerting with retries and logging.
- **Task 4:** Troubleshooting Scenario

---

## 📁 Project Structure

```
Assessment/
├── .github/workflows/
│ ├── dev-frontend.yml
│ └── prod-frontend.yml
├── app/
│ ├── app.js
│ ├── Dockerfile
│ └── package.json
├── Terraform/
│ ├── VPC/
│ ├── RDS/
│ ├── S3/
| ├── EKS/
│ └── terraform.hcl
```

## 🧱 Task 1 – Infrastructure as Code (Terraform)

- **Modules Implemented:**
  - VPC with 2 public and 2 private subnets across 2 AZs
  - S3 Bucket for static assets and logging
  - RDS (MySQL) with Multi-AZ option scaffolded
  - EKS deployment with Add-ons and Node group
- **Best Practices:**
  - Separated `dev.tfvars` and `prod.tfvars` for environments
  - Used remote state backend with S3 and DynamoDB
  - Workspaces used to separate environments cleanly

> All Terraform code is modular and reusable with a consistent structure per component.

---

## 🐳 Task 2 – Application + CI/CD

### Hello World App

- Node.js Express app returning `Hello World` on `/`
- Dockerized using `node:18-alpine` base image
- Lightweight and production-safe

### CI/CD (GitHub Actions)

- `dev-frontend.yml`:
  - Runs tests
  - Builds and pushes Docker image
  - Deploys automatically to dev
- `prod-frontend.yml`:
  - Requires manual approval for production deployment
  - Triggers on merge to `main`

> Docker images pushed to DockerHub (credentials managed via GitHub secrets)

---

## 🔧 Setup Instructions

### Terraform

```bash
cd Terraform/VPC
terraform init
terraform workspace new dev
terraform apply -var-file=tfvars/dev.tfvars
```
