terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# ----------------------------
# Network
# ----------------------------
resource "google_compute_network" "vpc" {
  name                    = "openstack-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "openstack-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# ----------------------------
# Firewall
# ----------------------------
resource "google_compute_firewall" "internal" {
  name    = "openstack-internal"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  source_ranges = ["10.0.0.0/24"]
  target_tags   = ["openstack"]
}

resource "google_compute_firewall" "ssh" {
  name    = "openstack-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["openstack"]
}

resource "google_compute_firewall" "api" {
  name    = "openstack-api"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "5000", "9696"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["openstack"]
}

# ----------------------------
# Controllers
# ----------------------------
resource "google_compute_instance" "controller" {
  count        = var.node_counts.controller
  name         = "controller-${count.index}"
  machine_type = "e2-standard-4"
  zone         = var.zone
  tags         = ["openstack", "controller"]

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
      size  = 50
      type  = "pd-ssd"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    # 10.0.0.10, 10.0.0.11, ...
    network_ip = "10.0.0.${10 + count.index}"
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key)}"
  }

  metadata_startup_script = file("${path.module}/bootstrap.sh")
}

# ----------------------------
# Computes
# ----------------------------
resource "google_compute_instance" "compute" {
  count        = var.node_counts.compute
  name         = "compute-${count.index}"
  machine_type = "e2-standard-4"
  zone         = var.zone
  tags         = ["openstack", "compute"]

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
      size  = 50
      type  = "pd-ssd"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    # 10.0.0.20, 10.0.0.21, ...
    network_ip = "10.0.0.${20 + count.index}"
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key)}"
  }

  metadata_startup_script = file("${path.module}/bootstrap.sh")
}

# ----------------------------
# Network nodes
# ----------------------------
resource "google_compute_instance" "network" {
  count        = var.node_counts.network
  name         = "network-${count.index}"
  machine_type = "e2-standard-4"
  zone         = var.zone
  tags         = ["openstack", "network"]

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
      size  = 40
      type  = "pd-ssd"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    # 10.0.0.30, 10.0.0.31, ...
    network_ip = "10.0.0.${30 + count.index}"
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key)}"
  }

  metadata_startup_script = file("${path.module}/bootstrap.sh")
}

# ----------------------------
# Storage (Ceph) nodes
# ----------------------------
resource "google_compute_instance" "storage" {
  count        = var.node_counts.storage
  name         = "storage-${count.index}"
  machine_type = "e2-standard-4"
  zone         = var.zone
  tags         = ["openstack", "storage"]

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
      size  = 40
      type  = "pd-ssd"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    # 10.0.0.40, 10.0.0.41, ...
    network_ip = "10.0.0.${40 + count.index}"
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key)}"
  }

  metadata_startup_script = file("${path.module}/bootstrap.sh")
}

# Extra disks for Ceph OSDs (one per storage node)
resource "google_compute_disk" "storage_osd" {
  count = var.node_counts.storage
  name  = "storage-osd-${count.index}"
  type  = "pd-balanced"
  size  = 50
  zone  = var.zone
}

resource "google_compute_attached_disk" "storage_osd_attach" {
  count    = var.node_counts.storage
  disk     = google_compute_disk.storage_osd[count.index].id
  instance = google_compute_instance.storage[count.index].id
}
