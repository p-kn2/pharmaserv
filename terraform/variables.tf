variable "aws_region" {
  description = "AWS Region for PharmaServ resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
  default     = "production"
}

variable "ecr_repository_name" {
  description = "Name of the ECR Repository"
  type        = string
  default     = "pharmaserv-api"
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "pharmaserv-eks-cluster"
}