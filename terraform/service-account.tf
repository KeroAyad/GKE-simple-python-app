resource "google_service_account" "gke-sa" {
  account_id   = "gke-sa-id"
  display_name = "GKE Service Account"
}

resource "google_project_iam_binding" "gke-binding" {
  project = var.project_id
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${google_service_account.gke-sa.email}",
  ]

  condition {
    title       = "expires_after_2022_11_31"
    description = "Expiring at midnight of 2022-11-31"
    expression  = "request.time < timestamp(\"2022-12-01T00:00:00Z\")"
  }
}