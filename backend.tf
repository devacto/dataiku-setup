# MANUAL: GCS bucket need to be created manually.
terraform {
  backend "gcs" {
    bucket = "tfstate-dataiku-candidate-vwibisono"
  }

  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

# To create SSH key to get into the instance
provider "tls" {
  // no config needed
}

provider "google" {
  region = "asia-southeast1"
  project = var.project_id
}
