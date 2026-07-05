
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an EXISTING EC2 Key Pair (in the target region) used for SSH access. Create one in the AWS console/CLI beforehand and put its name here."
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance. Restrict this to your own IP (e.g. 203.0.113.10/32) instead of 0.0.0.0/0 for better security."
  type        = string
  default     = "0.0.0.0/0"
}

variable "project_name" {
  description = "Name/tag prefix applied to all resources"
  type        = string
  default     = "terraform-nginx-ubuntu"
}
