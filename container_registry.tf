resource "google_container_registry" "dss_registry" {
  project    = var.project_id
  location   = "ASIA"
  depends_on = [google_project_service.client_service]
}

resource "google_storage_bucket_iam_member" "dss_gcr_access" {
  bucket = google_container_registry.dss_registry.id
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.dss_controller.email}"
}
