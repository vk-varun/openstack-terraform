variable "project_id" {
  description = "GCP project ID"
}

variable "region" {
  description = "GCP region"
  default     = "me-central1"
}

variable "zone" {
  description = "GCP zone"
  default     = "me-central1-a"
}

variable "public_key" {
  description = "Path to SSH public key (Cloud Shell default)"
  default     = "~/.ssh/google_compute_engine.pub"
}

variable "node_counts" {
  description = "Number of nodes per role"
  type = object({
    controller = number
    compute    = number
    network    = number
    storage    = number
  })
  default = {
    controller = 1
    compute    = 1
    network    = 1
    storage    = 1
  }
}

variable "vip_ip" {
  description = "Internal VIP for Kolla HAProxy"
  default     = "10.0.0.100"
}
