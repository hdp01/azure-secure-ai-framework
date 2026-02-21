# Secure Multi-Tenant AI Vision Framework (Azure + Terraform)

A robust, production-grade infrastructure framework for deploying sensitive vision-based AI services on Microsoft Azure. This project utilizes a **Silo Isolation Model** to ensure that data remains private, secure, and compliant.

## 🚀 Overview
Standard AI deployments often expose services via public endpoints. This framework eliminates that risk by ensuring all AI inferencing and data storage occurs within a private network backbone, accessible only through authenticated internal channels.

## 🛠️ Tech Stack
* **Infrastructure as Code:** Terraform
* **Cloud Provider:** Microsoft Azure
* **AI Service:** Azure AI Vision (Cognitive Services)
* **Security:** Private Link, Private DNS, Entra ID (RBAC)

## 🔒 Key Security Features
* **Network Isolation:** Public network access is disabled for all resources. Communication happens via **Private Endpoints**.
* **Zero-Trust Identity:** Disables local API key authentication (`local_auth_enabled = false`) in favor of **Managed Identities** and RBAC.
* **Dedicated Data Silos:** Isolated Storage Accounts for each tenant with firewall rules blocking all public internet traffic.
* **Custom Subdomain Routing:** Implements specific subdomains required for secure Private Link resolution.

## 📂 Project Structure
* `main.tf`: Core Terraform configuration for the VNet, AI Vision service, and Storage.
* `Azure_AI_Framework_Report.md`: Detailed architecture report and deployment proofs.
* `.gitignore`: Configured to protect sensitive Terraform state files.

## ⚙️ Quick Start
1. **Login to Azure:** `az login`
2. **Initialize:** `terraform init`
3. **Deploy:** `terraform apply`

---
*Developed as part of a Cloud Security & AI Infrastructure project.*