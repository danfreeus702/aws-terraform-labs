# AWS Learning Labs — Terraform on Floci

Hands-on labs for learning AWS and Infrastructure as Code with Terraform.
Everything runs locally against **Floci** — a free, open-source AWS emulator
(MIT licensed, Java/Quarkus, `github.com/floci-io/floci`) that implements the
standard AWS APIs. No AWS account, no credentials, no cost.

## Why this repo

I'm working toward becoming an AWS Cloud Engineer. These labs are my
learning record — small, working architectures that I can read, break,
destroy and rebuild until the concepts are second nature. Each lab includes
the Terraform code plus a README explaining what it builds and what to study.

## The environment

```
Terraform v1.17.2  (Docker wrapper on DietPi 14, 192.168.10.14)
Floci AWS emulator http://192.168.10.14:4566
Floci web UI       http://192.168.10.14:4500
```

Terraform is installed via a Docker wrapper at `/usr/local/bin/terraform`
on `.14` — it mounts the current directory and runs `hashicorp/terraform:latest`.
On that host, work from `/mnt/dietpi_userdata/terraform/<lab>/`.

## Labs

### [Lab 1 — S3 bucket](aws-lab-01/)
A single S3 bucket. Covers the core Terraform workflow: `init`, `plan`,
`apply`, `destroy`, providers, resources and outputs.

### [Lab 2 — S3 → Lambda → SQS](aws-lab-02/)
A small event-driven architecture: an S3 bucket, an SQS queue, an IAM role
with a least-privilege policy, and a Python Lambda that maps an S3 event to
an SQS message. Covers variables, `tfvars`, the dependency graph, IAM
policies, archive files and resource-to-resource references.

## Terraform workflow (same on real AWS)

```sh
cd <lab-directory>
terraform init      # download providers (first time only)
terraform plan      # preview changes — always read this first
terraform apply     # create the resources
terraform output    # show output values
terraform destroy   # tear everything down
```

## Moving to real AWS

When ready, create a free-tier AWS account, run `aws configure`, then in any
lab:

1. Remove the `endpoints {}` block from `provider.tf`
2. Remove the fake `access_key` / `secret_key` values
3. Run `terraform init && terraform plan` — the same code now targets real AWS

Set a billing alarm first.

## Concepts covered so far

- Infrastructure as Code with Terraform HCL
- Providers, resources, variables, outputs, locals, dependency graph
- S3, SQS, Lambda, IAM roles and policies, least privilege
- Local AWS emulation with Floci
- Git / GitHub for documenting and sharing learning progress

## Coming next

- S3 bucket notification triggering the Lambda (real event wiring)
- DynamoDB table + Terraform state backend
- VPC / subnets / security groups (networking — my CCNA background helps here)

---

*Daniel Freeman — CCNA (Cisco, 2006). Building toward AWS Cloud Engineer.*
