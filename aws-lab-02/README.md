# AWS Lab 2 — S3 → Lambda → SQS

A working AWS architecture built with Terraform against Floci (free local AWS emulator on .14).

## What this builds
- S3 bucket `cloud-lab-dev-landing` — landing zone for uploads
- SQS queue `cloud-lab-dev-events` — receives event messages
- IAM role + policy — least privilege for Lambda to write to SQS
- Lambda `cloud-lab-dev-notify` — Python code that maps an S3 event to an SQS message
- Outputs — how resources reference each other

## Study flow
1. Read `main.tf` top to bottom. Notice references like `aws_sqs_queue.events.arn`
   and `aws_iam_role.lambda_role.arn` — that is Terraform's dependency graph.
   Terraform works out the correct build order from these references.
2. Read `variables.tf` and `terraform.tfvars`. Change `environment` to "stage",
   run `plan`, and observe that names/tags change (resources get replaced).
3. `terraform plan` — read the "+" lines.
4. `terraform apply` — then open http://192.168.10.14:4500 to see everything.
5. `terraform destroy`, then `apply` again. This cycle is how you learn.

## Commands
```sh
cd /mnt/dietpi_userdata/terraform/aws-lab-02
terraform init        # first time only
terraform plan
terraform apply
terraform output
terraform state list
terraform destroy
```

## Key concepts to Google after this lab
- "Terraform dependency graph" — why .arn references create ordering
- "AWS IAM least privilege" — the policy grants only what Lambda needs
- "AWS Lambda S3 trigger" — real AWS needs aws_s3_bucket_notification (not used here)
- "Terraform state" — .tfstate is the source of truth; never edit by hand
