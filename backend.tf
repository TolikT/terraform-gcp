# GCS versioned bucket to store tf state file

terraform {
 backend "gcs" {
   bucket  = "atsikham-terraform-admin"
   prefix  = "terraform/state"
 }
}
