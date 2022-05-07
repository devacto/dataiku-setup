locals {
  name = "dataiku-dss"
  design_node_name = "${local.name}-design-node"
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

  service_account {
    email  = google_service_account.dss_controller.email
    scopes = ["cloud-platform"]
  }

  provisioner "file" {
    source = "install_packages.sh"
    destination = "/home/demouser/install_packages.sh"
    connection {
      host = google_compute_address.dss_design_node_static_ip.address
      type = "ssh"
      user = "demouser"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/demouser/install_packages.sh",
      "cd /home/demouser",
      "./install_packages.sh"
    ]
    connection {
      host = google_compute_address.dss_design_node_static_ip.address
      type = "ssh"
      user = "demouser"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "file" {
    source = "install_conda.sh"
    destination = "/home/demouser/install_conda.sh"
    connection {
      host = google_compute_address.dss_design_node_static_ip.address
      type = "ssh"
      user = "demouser"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/demouser/install_conda.sh",
      "cd /home/demouser",
      "./install_conda.sh"
    ]
    connection {
      host = google_compute_address.dss_design_node_static_ip.address
      type = "ssh"
      user = "demouser"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "file" {
    source = "install_docker.sh"
    destination = "/home/demouser/install_docker.sh"
    connection {
      host = google_compute_address.dss_design_node_static_ip.address
      type = "ssh"
      user = "demouser"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/demouser/install_docker.sh",
      "cd /home/demouser",
      "./install_docker.sh"
    ]
    connection {
      host = google_compute_address.dss_design_node_static_ip.address
      type = "ssh"
      user = "demouser"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "file" {
    source = "install_kubectl.sh"
    destination = "/home/demouser/install_kubectl.sh"
    connection {
      host = google_compute_address.dss_design_node_static_ip.address
      type = "ssh"
      user = "demouser"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/demouser/install_kubectl.sh",
      "cd /home/demouser",
      "./install_kubectl.sh"
    ]
    connection {
      host = google_compute_address.dss_design_node_static_ip.address
      type = "ssh"
      user = "demouser"
      private_key = tls_private_key.ssh.private_key_pem
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
    source = "install_dss.sh"
    destination = "/home/demouser/install_dss.sh"
    connection {
      host = google_compute_address.dss_design_node_static_ip.address
      type = "ssh"
      user = "demouser"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/demouser/install_dss.sh",
      "cd /home/demouser",
      "./install_dss.sh"
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
