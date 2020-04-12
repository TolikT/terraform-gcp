# Data resource used to lookup available Compute Engine zones, bound to the desired region. Avoids hard-coding of zone names
data "google_compute_zones" "available" {
  project = google_project.project.project_id
}

# The Compute Engine instance bound to the newly created project
resource "google_compute_instance" "default" {
  project      = google_project.project.project_id
  zone         = data.google_compute_zones.available.names[0]
  count        = var.compute_instance_count
  name         = "${var.compute_instance_prefix}-${count.index}"
  machine_type = var.compute_instance_type

  boot_disk {
    initialize_params {
      image = var.compute_instance_boot_disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  depends_on = [google_project_service.service]
}

