locals {
  dss_controller_permissions = [
    "roles/iam.serviceAccountUser",
    "roles/storage.admin",
    "roles/container.admin",
  ]
}

resource "google_service_account" "dss_controller" {
  project     = var.project_id
  account_id  = "dss-controller"
  description = "Account which the DSS Design Node executes on."
}

resource "google_project_iam_member" "dss_controller_permission" {
  for_each = toset(local.dss_controller_permissions)

  project = var.project_id
  member  = "serviceAccount:${google_service_account.dss_controller.email}"
  role    = each.key
}

resource "google_service_account_key" "dss_controller" {
  service_account_id = "${google_service_account.dss_controller.name}"
}

resource "local_file" "dss_controller_sa_key" {
  filename = "sa_key.json"
  content  = "${base64decode(google_service_account_key.dss_controller.private_key)}"
}
