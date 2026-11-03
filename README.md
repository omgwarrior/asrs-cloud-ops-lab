# asrs-cloud-ops-lab

**Independent AWS Cloud Operations interview demonstration** inspired by a publicly shared Engineer job description. **Not affiliated with, endorsed by, or deployed for Arizona State Retirement System (ASRS).** No agency data, credentials, or internal architecture are included.

## What is implemented

| Component | Status | Purpose |
|---|---|---|
| Python HTTP health service + Dockerfile | Runnable locally | Container and health checks |
| Terraform EC2 | Deployable example | EC2, IAM/SSM, IMDSv2, encrypted EBS |
| Terraform ECS Fargate | Deployable after image push | ECS service, logs, task execution IAM |
| Terraform EKS | Scaffold only | EKS design discussion; **does not deploy cluster** |
| Kubernetes Deployment/Service | Runnable with an available cluster and image | 2 replicas, probes, limits, restricted security context |
| GitHub Actions | Validation only | Terraform fmt/validate, Python syntax, Docker build |
| HA/security/migration docs | Design/runbooks | Technical interview walkthrough |

## Local quick start

```bash
cd asrs-cloud-ops-lab
docker build -t cloud-ops-demo:local .
docker run --rm -p 127.0.0.1:8080:8080 cloud-ops-demo:local
# separate terminal
curl -s http://127.0.0.1:8080/healthz
```

No Docker? `python3 app/server.py` runs the same service locally.

## EC2 demo (creates billable resources)

```bash
cd infra/ec2
terraform init
terraform plan
terraform apply
terraform output instance_id
terraform destroy
```

Requires AWS credentials, a default VPC, and account permissions. The EC2 example does **not** deploy the application. SSM connectivity depends on subnet routing/endpoints.

## ECS demo (creates billable resources)

First push the image to your own ECR repository (or select another accessible registry image). Then:

```bash
cd infra/ecs
terraform init
terraform plan -var='image=YOUR_IMAGE_URI'
terraform apply -var='image=YOUR_IMAGE_URI'
terraform destroy -var='image=YOUR_IMAGE_URI'
```

This deploys a private-to-ingress demonstration task, **not** an internet-facing service or HA stack. It uses the default VPC and public IP for image access. No ALB is created.

## EKS / existing Kubernetes cluster

`infra/eks` is intentionally a **non-deploying scaffold** to avoid surprise EKS charges. The `k8s/deployment.yaml` can run on an existing cluster after its image is loaded or changed to a reachable registry. For k3d, import the local image first:

```bash
k3d image import cloud-ops-demo:local -c interview
kubectl apply -f k8s/deployment.yaml
kubectl rollout status deployment/cloud-ops-demo
kubectl port-forward svc/cloud-ops-demo 8080:80
```

Replace `interview` with your actual k3d cluster name. Use an unused local port if 8080 is occupied.

## Interview talk track

"I built a small cloud operations reference lab to demonstrate EC2 versus ECS versus EKS selection, infrastructure as code, Git validation, secure defaults, and migration planning. The EC2 and ECS examples are intentionally small; the EKS and HA designs are documented rather than claimed as deployed. My emphasis is repeatable operations, security, cost controls, and measurable recovery procedures."

See [architecture and security](docs/architecture.md) and [migration runbook](docs/migration-runbook.md).

**Cost/security warning:** Do not deploy without checking your AWS account, region, service quotas, costs, and permissions. Never commit credentials or Terraform state.
