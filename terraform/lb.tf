resource "google_compute_instance_group" "website-group" {
  zone      = data.google_compute_zones.available.names[0]
  project   = google_project.project.project_id
  name      = "instance-pool"
  instances = google_compute_instance.website-instance.*.self_link
}

resource "google_compute_forwarding_rule" "website-forwarding-rule" {
  project               = google_project.project.project_id
  name                  = "website-forwarding-rule"
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.website-backend.self_link
  ports                 = [80]
}

resource "google_compute_region_backend_service" "website-backend" {
  project       = google_project.project.project_id
  backend {
    group       = google_compute_instance_group.website-group.self_link
  }
  name          = "website-backend"
  region        = var.region
  health_checks = [google_compute_health_check.tcp-80.self_link]
}

resource "google_compute_health_check" "tcp-80" {
  project            = google_project.project.project_id
  name               = "check-website-backend"
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port             = "80"
  }
}
