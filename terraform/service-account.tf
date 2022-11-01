resource "google_service_account" "gke-sa" {
  account_id   = "gke-sa-id"
  display_name = "GKE Service Account"
}

# data "google_iam_policy" "admin" {
#   binding {
#     role = "roles/artifactregistry.reader"
#     members = [
#       "serviceAccount:${google_service_account.gke-sa.email}",
#     ]
#   }
# }

# resource "google_artifact_registry_repository_iam_policy" "policy" {
#   project = var.project_id
#   location = var.region
#   repository = var.ar-repo
#   policy_data = data.google_iam_policy.admin.policy_data
# }

resource "google_project_iam_binding" "gke-binding" {
  project = var.project_id
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${google_service_account.gke-sa.email}",
  ]

  # condition {
  #   title       = "expires_after_2022_11_31"
  #   description = "Expiring at midnight of 2022-11-31"
  #   expression  = "request.time < timestamp(\"2022-12-01T00:00:00Z\")"
  # }
}
resource "google_project_iam_binding" "gke-binding-storage" {
  project = var.project_id
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.gke-sa.email}",
  ]

  # condition {
  #   title       = "expires_after_2022_11_31"
  #   description = "Expiring at midnight of 2022-11-31"
  #   expression  = "request.time < timestamp(\"2022-12-01T00:00:00Z\")"
  # }
}