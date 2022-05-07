locals {
  apis = toset(["compute.googleapis.com",
                "containerregistry.googleapis.com",
                "container.googleapis.com"])
}

# Activate GCP Compute Engine API
resource "google_project_service" "client_service" {
  for_each = local.apis

  service = each.value
  project = var.project_id

  disable_on_destroy         = false
  disable_dependent_services = true
}
