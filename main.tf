provider "google" {
    project = "prj-21032023-gets-nsvc-sv"
    region = "us-central1"
    zone = "us-central1-a"
  
}
resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  node_config {
    disk_size_gb= "10"
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.primary.id
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb = "10"
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  }
}
