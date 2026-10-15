# Root module for PROD; it calls the same reusable child module.
module "gcs_bucket" {
  source = "../../modules/gcs-bucket"

  bucket_name     = "dsu-module-prod-${var.project_id}"
  bucket_location = "US"
  storage_class   = "STANDARD"

  labels = {
    environment = "prod"
    managed_by  = "terraform"
  }
}
