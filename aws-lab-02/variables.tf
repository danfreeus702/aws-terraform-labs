variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
  default     = "cloud-lab"
}
variable "environment" {
  description = "Environment tag (dev/stage/prod)"
  type        = string
  default     = "dev"
}
variable "owner" {
  description = "Who owns these resources"
  type        = string
  default     = "Daniel"
}
