resource "google_container_cluster" "gke-cluster" {
  name       = "gke-cluster"
  location   = var.region
  network    = google_compute_network.gke-vpc-network.id
  subnetwork = google_compute_subnetwork.restricted-subnet.id
 
  remove_default_node_pool = true
  initial_node_count       = 1
  
  private_cluster_config {
    master_ipv4_cidr_block  = "172.16.0.0/28"
    enable_private_nodes    = true
    enable_private_endpoint = true
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "10.0.0.0/24"
    }
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.16.0.0/16"
    services_ipv4_cidr_block = "10.12.0.0/16"
  }


}


resource "google_container_node_pool" "gke-nodes" {
  name       = "gke-nodes"
  location   = var.region
  cluster    = google_container_cluster.gke-cluster.name
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = "e2-micro"
    tags         = ["gke-node"]
    # metadata = {
    #   disable-legacy-endpoints = "true"
    # }
    service_account = google_service_account.gke-sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    
  }
}