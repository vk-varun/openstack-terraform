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
  description = "Path to SSH public key"
}

variable "node_counts" {
  description = "Number of nodes per role"
  type = object({
    controller = number
    compute    = number
  })
  default = {
    controller = 2
    compute    = 2
  }
}

variable "vip_ip" {
  description = "Internal VIP for Kolla HAProxy"
  default     = "10.0.0.100"
}
