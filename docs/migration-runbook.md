# Migration runbook: legacy VM application to AWS

1. **Discover:** inventory servers, services, databases, DNS, firewall rules, integrations, batch jobs, and data classification. Capture baseline latency, throughput, and cost.
2. **Assess:** choose rehost (EC2), replatform (ECS), or refactor (EKS) based on application constraints, operational skills, cost, and risk. Define RTO/RPO and rollback criteria.
3. **Land:** AWS accounts, IAM, VPC, routes, private connectivity, DNS, logging, security controls, budgets, and Terraform state.
4. **Replicate:** use approved migration/replication tooling for data and workloads; keep source authoritative until planned cutover. Validate checksums, consistency, and dependencies.
5. **Test:** performance, failover, access, backups, restore, monitoring, and disaster recovery. Run a rehearsal with business owners.
6. **Cut over:** freeze changes as needed, final sync, update DNS/routing, monitor SLOs, and obtain acceptance.
7. **Rollback:** predefine decision thresholds, preserve source until acceptance, and rehearse restoring DNS and data direction; beware bidirectional writes.
8. **Optimize:** right-size, tag, monitor costs, patch, document and transfer operations.

## Sample interview response
"I start with dependency discovery and measurable recovery requirements. I select EC2, ECS or EKS based on the application rather than forcing containerization. I build the landing zone with Terraform, validate security and connectivity, rehearse cutover and rollback, and confirm operational readiness before decommissioning the source."
