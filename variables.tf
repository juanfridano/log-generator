variable "service_count" {
  description = " Number of services to create"
}

variable "image_url" {
  description = "URL of the container image from Artifact Registry"
}

variable "region" {
  description = "The region for the Cloud Run service"
}

variable "project" {
  description = "The project name"
}

variable "logging_frequency" {
  description = "How often should a log be created in seconds"
  default = 5
}

variable "service_account" {
  description = "Service account name"
}