provider "google" {
  project = var.project
  region  = var.region
}

resource "google_artifact_registry_repository" "log_repo" {
  provider     = google
  location     = var.region
  repository_id = "log-generator-repo"
  format       = "DOCKER"
}

resource "google_cloud_run_service" "log_service" {
  count = var.service_count
  name     = "log-service-${count.index}"
  location = var.region

  template {
    spec {
      containers {
        image = var.image_url
        env {
          name  = "LOG_FREQUENCY_SECONDS"
          value = var.logging_frequency
        }
      }
    }
  }

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all"
    }
  }

  autogenerate_revision_name = true

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "unauthenticated_access" {
  count   = var.service_count
  service = google_cloud_run_service.log_service[count.index].name
  location = var.region
  role    = "roles/run.invoker"
  member  = "allUsers"
}

resource "google_project_iam_binding" "cloud_run_logging" {
  project = var.project
  role    = "roles/run.invoker"
  members = [
    "serviceAccount:${var.service_account}@${var.project}.iam.gserviceaccount.com"
  ]
}

resource "google_service_account" "cloud_run_sa" {
  account_id   = var.service_account
  display_name = "Cloud Run Logging Service Account"
}
