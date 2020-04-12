# project variables
variable "project_name" {
  description = "project name"
}

variable "billing_account" {
  description = "billing account id"
}

variable "region" {
  description = "region (default: Frankfurt)"
  default     = "europe-west3"
}

# compute variables
variable "compute_instance_type" {
  description = "compute instance type"
  default     = "f1-micro"
}

variable "compute_instance_prefix" {
  description = "compute instance name prefix"
  default     = "tf-compute"
}

variable "compute_instance_count" {
  description = "compute instance count"
  default     = "1"
}

variable "compute_instance_boot_disk_image" {
  description = "boot disk image"
  default     = "ubuntu-1604-xenial-v20170328"
}

