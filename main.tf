locals {
  name = "dataiku-dss"
  design_node_name = "${local.name}-design-node"
  apis = toset(["compute.googleapis.com"])
}

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

# Create SSH key to get into the instance
provider "tls" {
  // no config needed
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = ".ssh/google_compute_engine"
  file_permission = "0600"
}

# Start GCP Provisioning
provider "google" {
  region = "asia-southeast1"
  project = var.project_id
}

# Activate GCP Compute Engine API
resource "google_project_service" "client_service" {
  for_each = local.apis

  service = each.value
  project = var.project_id

  disable_on_destroy         = false
  disable_dependent_services = true
}

# Dataiku Data Science Studio (DSS) VPC
resource "google_compute_network" "dss_vpc" {
  name = "${local.name}-vpc"
  depends_on = [google_project_service.client_service]
}

resource "google_compute_address" "dss_design_node_static_ip" {
  name = local.design_node_name
}

# Dataiku DSS Design Node
resource "google_compute_instance" "dss_design_node" {
  name         = local.design_node_name
  machine_type = "e2-standard-4"
  zone         = "asia-southeast1-a"
  tags         = ["${local.design_node_name}"]

  metadata = {
    ssh-keys = "demouser:${tls_private_key.ssh.public_key_openssh}"
  }

  boot_disk {
    initialize_params {
      size  = 50
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = google_compute_network.dss_vpc.name

    access_config {
      nat_ip = google_compute_address.dss_design_node_static_ip.address
    }
  }

  provisioner "file" {
    source = "license.json"
    destination = "/home/demouser/license.json"
    connection {
      host = google_compute_address.dss_design_node_static_ip.address
      type = "ssh"
      user = "demouser"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "file" {
    source = "install.sh"
    destination = "/home/demouser/install.sh"
    connection {
      host = google_compute_address.dss_design_node_static_ip.address
      type = "ssh"
      user = "demouser"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/demouser/install.sh",
      "cd /home/demouser",
      "./install.sh"
    ]
    connection {
      host = google_compute_address.dss_design_node_static_ip.address
      type = "ssh"
      user = "demouser"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }
}

output "public_ip" {
  value = google_compute_address.dss_design_node_static_ip.address
}

resource "google_compute_firewall" "allow_ssh" {
  name = "${local.design_node_name}-ssh"
  network = google_compute_network.dss_vpc.name
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  target_tags = ["${local.design_node_name}"]
  source_ranges = ["${var.ssh_ip}/32"]
}

resource "google_compute_firewall" "allow_http" {
  name = "${local.design_node_name}-web"
  network = google_compute_network.dss_vpc.name
  allow {
    protocol = "tcp"
    ports = ["10000"]
  }
  target_tags = ["${local.design_node_name}"]
  source_ranges = ["0.0.0.0/0"]
}
