
# Terraform AWS DevSecOps ECR Pipeline

This Repo implements a secure, automated DevSecOps CI/CD pipeline using Terraform, GitHub Actions, AWS ECR, OIDC authentication, SonarCloud, and Trivy. It is designed for building, scanning, and securely deploying containerized Node.js applications in a cloud-native manner — without hardcoded credentials.

---

## Purpose

To demonstrate a production-ready DevSecOps pipeline that:
- Uses **Terraform** for infrastructure provisioning
- Uses **GitHub Actions** for CI/CD orchestration
- Scans code and containers with **SonarQube** and **Trivy**
- Pushes container images to **Amazon ECR**
- Secures everything with **OIDC-based authentication**

---

## Stack & Components

| Component     | Role                                                                 |
|---------------|----------------------------------------------------------------------|
| **Terraform** | Infrastructure as Code: AWS ECR, IAM Roles for OIDC                  |
| **GitHub Actions** | CI/CD pipeline using secure, secretless access to AWS           |
| **Docker**    | Build and tag Node.js app images                                      |
| **Amazon ECR**| Stores Docker images for deployment                                   |
| **OIDC**      | Federated identity (GitHub → AWS) without storing credentials         |
| **SonarCloud**| Static code analysis for code quality and vulnerabilities            |
| **Trivy**     | Vulnerability scanning of Docker images (OS and dependencies)         |

---

## Why SonarCloud & Trivy Are Important

### SonarCloud (SonarQube)
SonarCloud statically analyzes your source code to:
- Detect **code smells**, **bugs**, **security vulnerabilities**
- Track **technical debt**
- Enforce **coding standards**
- Perform **secret detection**
- Identify **duplicated code**, **unused code**, or **anti-patterns**

_SonarCloud analyzes the source code before it is compiled or deployed._

---

### Trivy
Trivy scans Docker images for:
- OS-level vulnerabilities (e.g., Alpine, Ubuntu)
- Language-specific package vulnerabilities (e.g., npm, pip)
- Known CVEs from **OS**, **libraries**, **binaries**
- Misconfigurations and exposed secrets

_Trivy focuses on the built Docker image itself — the final artifact._

---

### Why They're Not the Same as `scan_on_push`
Terraform allows enabling this ECR config:
```hcl
image_scanning_configuration {
  scan_on_push = true
}
```
But this AWS feature is limited:
- Only checks **OS-level packages**
- Uses **Amazon Inspector**, not customizable
- No context of application logic or npm libraries

✅ SonarCloud + Trivy provide **deeper, broader, and customizable** scanning.

---

## CI/CD Workflow Overview

On every `main` branch push, the following steps run:

1. ✅ **Checkout the Code**
2. ✅ **Install Dependencies** (`npm install`)
3. ✅ **Run SonarCloud Scan**
4. ✅ **Build Docker Image**
5. ✅ **Scan Image with Trivy**
6. ✅ **Configure AWS Credentials via OIDC**
7. ✅ **Push Image to ECR with Git SHA tag**

---

## Example Pipeline Results

### SonarCloud Scan Output

```log
INFO: Scanner configuration file: /opt/sonar-scanner/conf/sonar-scanner.properties
INFO: Project root configuration file: /github/workspace/sonar-project.properties
INFO: Load global settings
INFO: ------------- Scan devsecops2 -------------
INFO: 6 source files indexed
INFO: ------------- Analysis Success -------------
INFO: More about the report at:
https://sonarcloud.io/dashboard
```

---

### Trivy Scan Output

```log
devsecops (alpine 3.18)
=======================
Total: 6 (CRITICAL: 0, HIGH: 2, MEDIUM: 3, LOW: 1)

│ Library │ Vulnerability ID │ Severity │ Installed Version  │ Fixed Version  │
│---------│------------------│----------│--------------------│----------------│
│ musl    │ CVE-2023-47625   │ HIGH     │ 1.2.4-r1           │ 1.2.4-r2       │
│ npm     │ CVE-2024-12345   │ HIGH     │ 9.6.0              │ 9.6.1          │
│ zlib    │ CVE-2022-37434   │ MEDIUM   │ 1.2.13-r1          │ 1.2.13-r2      │
```

---

### Docker Build & Push

```log
Successfully built image: devsecops:latest
Successfully tagged: <your_account>.dkr.ecr.us-east-1.amazonaws.com/devsecops:<github_sha>
Pushed image to ECR ✅
```

---

## Repo Structure

```bash
tf-aws-devsecops-ecr-pipeline/
├── app.js
├── Dockerfile
├── package.json
├── sonar-project.properties
├── .github/
│   └── workflows/
│       └── devsecops.yaml
└── infra/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── oidc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ecr/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Usage

### Deploy Infrastructure & Set GitHub Secrets
```bash
cd infra
make deploy
```

### Trigger CI/CD
```bash
git commit -m "Trigger pipeline"
git push origin main
```

### Destroy Infrastructure
```bash
make delete
```

---

## Author

**Fekri Saleh**  
Cloud Architect • DevOps Engineer • IEEE Author  
📍 Calgary, Alberta, Canada  
🔗 [LinkedIn](https://www.linkedin.com/in/fekri600)  
🔗 [GitHub](https://github.com/fekri600)
