resource "google_compute_network" "gke-vpc-network" {
  name = "gke-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "management-subnet" {
  name          = "management-subnet"
  ip_cidr_range = var.management-subnet-cidr
  region        = var.region
  network       = google_compute_network.gke-vpc-network.id
  private_ip_google_access = true
}

resource "google_compute_router" "management-router" {
  name    = "management-router"
  region  = google_compute_subnetwork.management-subnet.region
  network = google_compute_network.gke-vpc-network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "management-nat" {
  name                   = "managment-router-nat"
  router                 = google_compute_router.management-router.name
  region                 = google_compute_router.management-router.region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.management-subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]

  }

}


resource "google_compute_subnetwork" "restricted-subnet" {
  name          = "restricted-subnet"
  ip_cidr_range = var.restricted-subnet-cidr
  region        = var.region
  network       = google_compute_network.gke-vpc-network.id
  # private_ip_google_access = true
}


