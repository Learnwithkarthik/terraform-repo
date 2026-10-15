# Root module for DEV; it calls the same reusable child module.
module "gcs_bucket" {
  source = "../../modules/gcs-bucket"

  bucket_name     = "dsu-module-dev-${var.project_id}"
  bucket_location = "US"
  storage_class   = "STANDARD"

  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
