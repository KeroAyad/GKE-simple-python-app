resource "google_compute_instance" "management-vm" {
  name         = "management-vm"
  machine_type = "e2-micro"
  zone         = var.region

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

   network_interface {
    network = google_compute_network.gke-vpc-network.id
    subnetwork = google_compute_subnetwork.management-subnet.id
    # access_config {
    #   // Ephemeral public IP
    # }
  }
}

resource "google_compute_firewall" "management-firewall" {
  name    = "management-firewall"
  network = google_compute_network.gke-vpc-network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"] // Google IAP CIDR
}