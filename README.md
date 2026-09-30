# 🚀 Azure Infrastructure CI/CD with Terraform & Azure DevOps

> **End-to-end Infrastructure-as-Code (IaC) pipeline for Azure using Terraform and Azure DevOps — with validation, security scanning, cost analysis, plan artifact, manual approval, and controlled deployment.**

![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA?logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft-Azure-0078D4?logo=microsoftazure&logoColor=white)
![Azure DevOps](https://img.shields.io/badge/Azure-DevOps-0078D7?logo=azuredevops&logoColor=white)
![Security](https://img.shields.io/badge/DevSecOps-Enabled-success)
![Status](https://img.shields.io/badge/Pipeline-Completed-brightgreen)

---

## 📌 Project Overview

This project demonstrates a **production-style Azure Infrastructure CI/CD pipeline** built with:

- **Terraform** for Infrastructure as Code
- **Azure DevOps Pipelines** for CI/CD orchestration
- **Azure Storage** for Terraform remote state
- **Azure Key Vault + Customer Managed Key (CMK)** for encryption
- **User Assigned Managed Identity** for Azure authentication/permissions
- **Azure RBAC** for access control
- **TFLint + tfsec + Trivy** for security and IaC scanning
- **Infracost** for infrastructure cost analysis
- **Terraform plan artifact** for controlled deployment
- **Manual approval** before production-style infrastructure changes

The objective was not simply to run:

```bash
terraform apply
```

The objective was to build a **controlled, secure, auditable and repeatable infrastructure deployment workflow**.

---

## 🏗️ End-to-End Pipeline

```text
┌─────────────────────┐
│  Terraform Code     │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  01. Validation     │
│  fmt / validate     │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  02. Security Scan  │
│  TFLint / tfsec     │
│  Trivy / Infracost  │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  03. Terraform Plan │
│  terraform plan     │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  Publish tfplan     │
│  as Pipeline Artifact│
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  04. Manual Approval│
│  Review plan        │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  05. Terraform Apply│
│  apply saved plan   │
└──────────┬──────────┘
           ↓
      ☁️ Azure
```

### 🔐 Important Design Principle

**Plan and Apply are deliberately separated.**

```bash
terraform plan -out=tfplan
```

⬇️

```text
Publish tfplan as pipeline artifact
```

⬇️

```text
Manual approval / review
```

⬇️

```bash
terraform apply tfplan
```

This makes the deployment process controlled: the pipeline applies the **reviewed Terraform plan artifact**, rather than creating a new plan during the apply stage.

---

## 🛡️ Security & Quality Gates

| Stage | Controls |
|---|---|
| Terraform Validation | `terraform fmt`, `terraform validate` |
| IaC Linting | TFLint |
| Security Scanning | tfsec |
| Secret / IaC Scanning | Trivy |
| Cost Analysis | Infracost |
| Authentication | Managed Identity / Azure AD-based authentication |
| Authorization | Azure RBAC |
| Encryption | Key Vault + Customer Managed Key |
| Deployment Control | Manual approval |
| Deployment Integrity | Saved Terraform plan artifact |

---

## 🔧 Key Implementations

### 1. Terraform Remote State

Terraform state is stored remotely in **Azure Storage** instead of the local machine.

Benefits:

- Centralized state
- Team collaboration
- State persistence
- Controlled access through Azure
- Better separation between code and state

---

### 2. Reusable Terraform Child Modules

Infrastructure components are separated into reusable modules.

Example:

```text
Child Module/
│
├── azurerm_cmk_identity/
│   ├── main.tf
│   └── output.tf
│
├── azurerm_key_vault/
│   ├── main.tf
│   └── output.tf
│
├── azurerm_resource_group/
│   ├── main.tf
│   └── variables.tf
│
└── azurerm_storage_account/
    ├── main.tf
    └── variables.tf
```

This keeps the infrastructure code **modular, reusable and easier to maintain**.

---

## 🌎 Environment Separation

```text
environments/
│
├── Dev/
│   ├── main.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   └── variables.tf
│
└── Prod/
    ├── main.tf
    ├── provider.tf
    ├── terraform.tfvars
    └── variables.tf
```

The same reusable modules can be consumed by different environments with environment-specific variables.

---

## 📂 Repository Structure

```text
.
├── Child Module/
│   ├── azurerm_cmk_identity/
│   │   ├── main.tf
│   │   └── output.tf
│   │
│   ├── azurerm_key_vault/
│   │   ├── main.tf
│   │   └── output.tf
│   │
│   ├── azurerm_resource_group/
│   │   ├── main.tf
│   │   └── variables.tf
│   │
│   └── azurerm_storage_account/
│       ├── main.tf
│       └── variables.tf
│
├── environments/
│   ├── Dev/
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   │
│   └── Prod/
│       ├── main.tf
│       ├── provider.tf
│       ├── terraform.tfvars
│       └── variables.tf
│
├── pipelines/
│   ├── terraform-ci.yml
│   └── terraform-cd.yml
│
├── docs/
│   └── images/
│       ├── azure-infra-pipeline.png
│       └── azure-devops-pipeline.png
│
└── README.md
```

> If your actual pipeline YAML files have different names or locations, update the `pipelines/` section accordingly.

---

## 🧩 Example Child Module Usage

```hcl
module "resource_group" {
  source = "../../Child Module/azurerm_resource_group"

  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
```

The goal is to keep the environment configuration lightweight while moving reusable resource definitions into modules.

---

## ☁️ Azure Architecture

The infrastructure design follows a management-group-oriented Azure Landing Zone style:

```text
                    Root Management Group
                             │
             ┌───────────────┼────────────────┐
             │               │                │
          Platform        Workloads         Sandbox
             │               │
     ┌───────┼───────┐   ┌───┴─────────┐
     │       │       │   │             │
 Connectivity Identity Management   Production
                                      Non-Production
```

Supporting services/components include:

- Azure SQL
- Storage Account
- Azure Key Vault + CMK
- Log Analytics
- Microsoft Sentinel
- Azure RBAC / PIM / JIT
- Backup / DR considerations
- RPO / RTO considerations

---

## 🔐 Authentication & Authorization

The pipeline is designed around Azure identity-based access rather than embedding long-lived credentials in Terraform code.

Key concepts demonstrated:

```text
Azure DevOps
      │
      ↓
Azure Authentication
      │
      ↓
Managed Identity / Federated Identity
      │
      ↓
Azure RBAC
      │
      ↓
Azure Resources
```

Secrets and encryption-related components are handled through **Azure Key Vault and Customer Managed Keys** where required.

> Never commit Azure client secrets, service-principal passwords, Terraform state files, or other sensitive credentials to Git.

---

## 💰 Infrastructure Cost Analysis

**Infracost** is included as a cost-analysis gate to provide visibility into the estimated cost impact of infrastructure changes.

Typical workflow:

```text
Terraform Code
      ↓
Terraform Plan
      ↓
Infracost
      ↓
Estimated Cost Impact
      ↓
Review
```

This helps teams consider cost as part of the infrastructure change process.

---

## 🔍 Security Scanning

The pipeline integrates multiple layers of Terraform/IaC checks:

```text
                 Terraform Code
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
       TFLint        tfsec        Trivy
          │            │            │
          └────────────┼────────────┘
                       ↓
                  Security Gate
```

### Tools

- **TFLint** → Terraform linting and configuration quality
- **tfsec** → Terraform security analysis
- **Trivy** → IaC/security/secret scanning
- **Infracost** → Cost estimation

---

## 📦 Terraform Plan Artifact

One of the most important parts of this pipeline is the use of a **saved Terraform plan artifact**.

### Plan stage

```bash
terraform plan -out=tfplan
```

Then the generated plan is published as an Azure DevOps pipeline artifact.

### Apply stage

The artifact is downloaded and applied:

```bash
terraform apply tfplan
```

### Why?

It prevents the pipeline from simply generating a fresh plan during deployment.

Conceptually:

```text
Code
 ↓
Plan
 ↓
Review
 ↓
Approve
 ↓
Apply SAME PLAN
```

This creates a clearer separation between **change generation, review and deployment**.

---

## 👤 Manual Approval

Before infrastructure changes are deployed, the pipeline pauses for an approval gate.

```text
Terraform Plan
      ↓
Publish Artifact
      ↓
Manual Review
      ↓
Approval
      ↓
Terraform Apply
```

This is especially useful for controlled environments where infrastructure changes require human review.

---

## 🛠️ Real-World Troubleshooting Areas

During implementation, several Azure/Terraform integration areas required troubleshooting, including:

- Azure RBAC permissions
- Key Vault firewall/network restrictions
- Managed Identity permissions
- Customer Managed Key integration
- Terraform module references
- Pipeline artifact handling
- Terraform state/backend access
- Infrastructure security checks

These issues were useful in validating that the pipeline was not just theoretical but also exercised real infrastructure integration points.

---

## 📊 Pipeline Execution

Example Azure DevOps execution flow:

```text
Terraform CI
     ↓
Security Scan
     ↓
Terraform Plan
     ↓
Manual Approval
     ↓
Terraform Apply
     ↓
Azure Infrastructure
```

The demonstrated pipeline completed the end-to-end workflow successfully.

---

## ▶️ How to Run

### Prerequisites

Install/configure:

- Terraform
- Azure CLI
- Azure DevOps project
- Azure subscription
- Appropriate Azure RBAC permissions
- Required Terraform providers
- TFLint
- tfsec
- Trivy
- Infracost

### 1. Clone the repository

```bash
git clone <YOUR-GITHUB-REPOSITORY-URL>
cd <YOUR-REPOSITORY>
```

### 2. Authenticate with Azure

```bash
az login
az account set --subscription "<SUBSCRIPTION-ID>"
```

### 3. Initialize Terraform

```bash
cd environments/Dev
terraform init
```

### 4. Validate

```bash
terraform fmt -check
terraform validate
```

### 5. Create a plan

```bash
terraform plan -out=tfplan
```

### 6. Review

Review the Terraform plan before deployment.

### 7. Apply

```bash
terraform apply tfplan
```

> For the Azure DevOps workflow, use the pipeline rather than manually applying production infrastructure.

---

## ⚠️ Important Security Notes

Before pushing this project to GitHub:

- Do **not** commit `.tfstate` files.
- Do **not** commit `.tfstate.backup`.
- Do **not** commit Azure client secrets.
- Do **not** commit service-principal credentials.
- Do **not** commit private keys.
- Do **not** commit Key Vault secrets.
- Keep sensitive values in secure pipeline variables, variable groups, Key Vault, or another approved secret-management solution.
- Use `.gitignore` for Terraform-generated and sensitive files.

Recommended `.gitignore` entries:

```gitignore
# Terraform
.terraform/
*.tfstate
*.tfstate.*
crash.log
crash.*.log

# Terraform plan files
*.tfplan
tfplan

# Variable files containing secrets
*.tfvars
*.tfvars.json

# Local environment
.env
.env.*

# IDE
.vscode/
.idea/
```

> If your repository intentionally contains non-sensitive example `.tfvars` files, keep only sanitized example values and document that clearly.

---

## 🎯 What This Project Demonstrates

### Infrastructure as Code

```text
Terraform
├── Reusable Modules
├── Environment Separation
├── Remote State
└── Repeatable Infrastructure
```

### DevSecOps

```text
Terraform
   ↓
Lint
   ↓
Security Scan
   ↓
Secret Scan
   ↓
Cost Analysis
   ↓
Plan
   ↓
Approval
   ↓
Deploy
```

### Azure

```text
Azure
├── Resource Groups
├── Storage
├── Key Vault
├── Customer Managed Key
├── Managed Identity
├── RBAC
├── Monitoring
└── Landing Zone concepts
```

---

## 🧠 Key Engineering Learnings

This project helped reinforce several practical infrastructure engineering concepts:

1. **Infrastructure should be repeatable.**
2. **Security checks should happen before deployment.**
3. **Terraform plan and apply should be controlled separately when change approval is required.**
4. **Artifacts can provide a hand-off point between pipeline stages.**
5. **Identity-based authentication is preferable to embedding long-lived credentials.**
6. **Reusable Terraform modules reduce duplication.**
7. **Infrastructure cost should be considered before deployment.**
8. **Production infrastructure needs both automation and governance.**
9. **Troubleshooting Azure permissions and networking is an important part of real-world IaC work.**

---

## 📸 Pipeline Screenshots

Add the screenshots generated during the pipeline execution under:

```text
docs/images/
```

Suggested files:

```text
docs/images/azure-infra-pipeline.png
docs/images/azure-devops-pipeline.png
```

Then display them in this README:

```markdown
## 📸 Pipeline Execution

![Azure Infrastructure CI/CD Pipeline](docs/images/azure-infra-pipeline.png)

![Azure DevOps Pipeline Stages](docs/images/azure-devops-pipeline.png)
```

---

## 🏁 Final Workflow

```text
┌──────────┐
│ Validate │
└────┬─────┘
     ↓
┌──────────┐
│   Scan   │
└────┬─────┘
     ↓
┌──────────┐
│   Plan   │
└────┬─────┘
     ↓
┌──────────┐
│  Review  │
└────┬─────┘
     ↓
┌──────────┐
│ Approve  │
└────┬─────┘
     ↓
┌──────────┐
│  Deploy  │
└────┬─────┘
     ↓
   ☁️ Azure
```

### `Validate → Scan → Plan → Review → Approve → Deploy`

---

## 👨‍💻 Author

**Akram Raza**

DevOps / Cloud Infrastructure Engineer

**Focus Areas:**

`Azure` • `Terraform` • `Azure DevOps` • `CI/CD` • `Infrastructure as Code` • `DevSecOps` • `Kubernetes` • `Cloud Automation`

---

⭐ If this project is useful, feel free to explore the Terraform modules and pipeline implementation.

> **Build infrastructure like software: versioned, tested, secured, reviewed and repeatable.**
