resource "google_compute_instance" "this" {
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }
  machine_type = "e2-micro"
  name         = "${var.identifier}-instance"
  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name
  }
  zone = var.zone
}
