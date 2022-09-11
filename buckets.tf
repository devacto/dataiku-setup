resource "google_storage_bucket" "dss_datasets" {
  project = var.project_id
  name    = "dss-datasets"

  location                    = "ASIA-SOUTHEAST1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  force_destroy               = true
  labels                      = {
    "app" = local.design_node_name
  }
}

resource "google_storage_bucket_iam_member" "dss_datasets_object_admin" {
  bucket = google_storage_bucket.dss_datasets.name
  member = "serviceAccount:${google_service_account.dss_controller.email}"
  role   = "roles/storage.objectAdmin"
}
