## Overview

This repository contains solutions for the DevOps Engineer Skills Assessment.

- **Task 1:** Provision infrastructure using Terraform modules (VPC, RDS, S3)
- **Task 2:** Containerize a Node.js application and implement CI/CD with GitHub Actions
- **Task 3:** Monitoring & Automation: include a Python script for URL health checks and Slack/email alerting with retries and logging.
- **Task 4:** Troubleshooting Scenario

---

## Project Structure

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
│ └── EKS/
```

## Task 1 – Infrastructure as Code (Terraform)

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

## Task 2 – Application + CI/CD

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

## Setup Instructions

### Terraform

```bash
cd Terraform/VPC
terraform init
terraform workspace new dev
terraform apply -var-file=tfvars/dev.tfvars
```

## Task 4 - Troubleshooting Production 500 Errors

### Scenario

Production applications are intermittently returning **HTTP 500 errors** during peak traffic. These correlate with **high CPU usage** on the **database server (RDS MySQL)**.

---

### Investigation Plan

1. **Reproduce the issue:**
   - Use monitoring tools (CloudWatch, Datadog, etc.) to visualize CPU spikes and error rates over time.
   - Check logs (application + RDS) for stack traces or slow queries.

2. **Inspect RDS performance:**
   - Look at `CPUUtilization`, `DatabaseConnections`, and `ReadIOPS/WriteIOPS`.
   - Enable enhanced monitoring and Performance Insights to trace query load.

3. **Check application behavior:**
   - Analyze any synchronous DB calls in hot paths (e.g., on user login or homepage).
   - Confirm connection pooling and timeout configuration are sane.

4. **Database-level review:**
   - Run `SHOW PROCESSLIST` and analyze long-running queries.
   - Profile slow queries using `slow_query_log` and indexing strategy.

---

### Immediate Stabilization Steps

- **Scale the RDS instance vertically** (larger instance type) or temporarily switch to burstable class with credit surplus.
- **Offload reads** to a read replica if one exists.
- **Raise application connection timeouts** to avoid retry storms from client failures.

---

### Long-Term Architectural Solutions

- **Migrate to Aurora MySQL**, which offers better performance and scaling.
- **Adopt a microservice architecture** to separate read-heavy and write-heavy components.
- **Introduce a message queue** (SQS, Kafka) to decouple heavy write operations.
- **Optimize queries** and database schema via indexing, denormalization, or query refactoring.
- **Implement horizontal scaling** of backend services using ECS/Kubernetes and autoscaling policies.

---

### Preventive Monitoring Plan

- **Set CloudWatch Alarms** on RDS metrics (`CPUUtilization > 80%`, `DatabaseConnections > threshold`).
- **Use distributed tracing** (e.g., OpenTelemetry, X-Ray) to trace slow DB queries per API call.
- **Implement SLOs and alerts** for 500 error rate thresholds per route.
- **Add health checks and synthetic monitoring** to detect failures proactively.

---

### Summary

This multi-layered approach balances **short-term mitigation**, **root cause diagnosis**, and **long-term system hardening**. It aims to stabilize production while building resilience for future traffic surges.
