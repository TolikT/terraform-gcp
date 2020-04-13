# Data resource used to lookup available Compute Engine zones, bound to the desired region. Avoids hard-coding of zone names
data "google_compute_zones" "available" {
  project = google_project.project.project_id
}

# The Compute Engine instance bound to the newly created project
resource "google_compute_instance" "website-instance" {
  project      = google_project.project.project_id
  zone         = data.google_compute_zones.available.names[0]
  count        = var.compute_instance_count
  name         = "${var.compute_instance_prefix}-${count.index}"
  machine_type = var.compute_instance_type
  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key)}"
  }
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

# Allow ssh/http access
resource "google_compute_firewall" "allow-ssh-http" {
  project = google_project.project.project_id
  name    = "allow-ssh-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
}

output "instance_ext_ip" {
  value = google_compute_instance.website-instance.*.network_interface.0.access_config.0.nat_ip
}

