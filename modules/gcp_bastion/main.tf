resource "google_compute_firewall" "allow-ssh-target-bastion" {
  allow {
    ports = [
      "22"
    ]
    protocol = "tcp"
  }
  name     = "allow-ssh-target-bastion"
  network  = var.network_name
  priority = 1000
  target_tags = [
    "bastion"
  ]
}

resource "google_compute_firewall" "allow-ssh-source-bastion" {
  allow {
    ports = [
      "22"
    ]
    protocol = "tcp"
  }
  name     = "allow-ssh-source-bastion"
  network  = var.network_name
  priority = 1000
  source_tags = [
    "bastion"
  ]
}

resource "google_compute_instance" "this" {
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }
  machine_type = "e2-micro"
  name         = "${var.identifier}-bastion"
  network_interface {
    access_config {
        network_tier = "STANDARD"
    }
    network    = var.network_name
    subnetwork = var.subnet_name
  }
  tags = [
    "bastion"
  ]
  zone = var.zone
}
