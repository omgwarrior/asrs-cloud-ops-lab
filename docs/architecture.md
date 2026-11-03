# Architecture and trade-offs

## Three deployment targets

- **EC2**: single EC2 instance, Amazon Linux 2023, IMDSv2, encrypted EBS, no inbound security group rules, SSM role. It does **not** install the sample application. This is an infrastructure/management example, not an HA application stack.
- **ECS**: Fargate task and service with CloudWatch logging. The demo uses default VPC/public subnets and public IP for image pull; no inbound access. It is not publicly reachable and is not production-ready. An image must be built/pushed first.
- **EKS**: Terraform scaffold and Kubernetes deployment manifest. **No EKS cluster is provisioned**. For a real EKS design, use private subnets in at least two AZs, managed node groups, endpoint restrictions, EKS control-plane logs, pod identity/IRSA, and managed add-ons.

## HA target architecture (design, not deployed)

Clients -> Route 53 -> AWS WAF -> ALB in two AZs -> ECS tasks or EKS pods across two AZs -> RDS Multi-AZ / durable storage. CloudWatch metrics/logs, IAM least privilege, KMS encryption, AWS Backup, and tested restore procedures.

Set service autoscaling from CPU, latency, or queue depth. Test zonal failures, configure health checks and deploy circuit breakers. Define RTO and RPO with stakeholders. Do not confuse two replicas with end-to-end high availability.

## Security and cost

The example deliberately avoids secrets and broad ingress. Production design: private subnets, NAT or VPC endpoints, restricted egress, scoped IAM, secrets in Secrets Manager, ECR scanning, CloudTrail, Config, GuardDuty, WAF, tagging, budgets, and alarms. AWS resources incur charges; `terraform destroy` when finished. Public cloud deployment requires your own account and approvals.

## Interview walkthrough

1. Describe EC2 vs ECS vs EKS selection: VM control vs managed container scheduling vs Kubernetes ecosystem/portability.
2. Explain how Terraform plan/review/apply and GitHub Actions CI separate validation from production changes.
3. Walk through least privilege, private networking, monitoring, and rollback.
4. Explain how to migrate a legacy multi-tier application using dependency mapping, parallel run, cutover, and tested rollback.
5. Distinguish runnable examples from future-state HA and EKS architecture.
