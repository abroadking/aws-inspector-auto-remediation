# AWS Inspector Auto-Remediation

This project automatically handles AWS Inspector findings using a Lambda function triggered by EventBridge. It enhances cloud security visibility and speeds up incident response using AWS-native services.

---

## **Overview**

When AWS Inspector detects a vulnerability, an **EventBridge rule** triggers a **Lambda function**. This function processes the finding, applies custom logic (e.g., tag priority level, log, or forward), and optionally integrates with **Security Hub**.

---

## **Architecture**

- **AWS Inspector** – Detects vulnerabilities in EC2, Lambda, or containers.
- **EventBridge** – Captures Inspector findings and routes them to Lambda.
- **Lambda** – Python function to auto-triage findings.
- **Terraform** – Used to provision EventBridge rule, Lambda function, IAM roles.

---

## **Use Case**

> You're managing workloads on AWS. Inspector flags a high-severity CVE. This setup automatically classifies the finding, tags the resource, and prepares it for remediation—all without human intervention.

---

## **Technologies Used**

- AWS Lambda (Python)
- AWS Inspector
- AWS EventBridge
- AWS Security Hub
- Terraform (IaC)

---

## **Getting Started**

### **1. Clone the Repo**
```bash
git clone https://github.com/yourusername/aws-inspector-auto-remediation.git
cd aws-inspector-auto-remediation
