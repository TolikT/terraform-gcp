# The Google cloud provider config. The credentials will be pulled using the GOOGLE_APPLICATION_CREDENTIALS environment variable
provider "google" {
  region = var.region
}

# Generate a random id prefixed by project name
resource "random_id" "id" {
  byte_length = 4
  prefix      = var.project_name
}

# The new project to create
resource "google_project" "project" {
  name            = var.project_name
  project_id      = random_id.id.hex
  billing_account = var.billing_account
}

# Services and APIs enabled within the new projec
resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com"
  ])

  service = each.key

  project            = google_project.project.project_id
  disable_on_destroy = false
}

# Display generated project id after Terraform runs for reference 
output "project_id" {
  value = google_project.project.project_id
}
