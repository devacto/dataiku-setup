# Dataiku Data Science Studio (DSS) VPC
resource "google_compute_network" "dss_vpc" {
  name = "${local.name}-vpc"
  depends_on = [google_project_service.client_service]
}

resource "google_compute_address" "dss_design_node_static_ip" {
  name = local.design_node_name
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

resource "google_compute_firewall" "allow_internal_comms" {
  name = "${local.design_node_name}-internal"
  network = google_compute_network.dss_vpc.name
  allow {
    protocol = "tcp"
    ports = ["1-65535"]
  }
  target_tags = ["${local.design_node_name}"]
  source_ranges = ["10.64.0.0/14"]
}
