locals {
  dss_controller_permissions = [
    "roles/storage.admin",
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
