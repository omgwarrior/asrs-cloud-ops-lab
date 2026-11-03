terraform {
 required_version = ">= 1.5.0"
 required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.region }
variable "region" { type = string; default = "us-west-2" }
variable "cluster_name" { type = string; default = "cloud-ops-demo" }
variable "kubernetes_version" { type = string; default = "1.33" }
# EKS reference scaffold: intentionally does not provision an expensive cluster.
# Implement VPC private subnets, EKS cluster IAM, node IAM, EKS cluster,
# managed node groups, endpoint access restrictions, and audit logging
# only after selecting a supported Kubernetes version and cost budget.
output "design_status" { value = "EKS scaffold only; see docs/architecture.md" }
