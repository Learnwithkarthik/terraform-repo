# Root module for TEST; it calls the same reusable child module.
module "gcs_bucket" {
  source = "../../modules/gcs-bucket"

  bucket_name     = "dsu-module-test-${var.project_id}"
  bucket_location = "EU"
  storage_class   = "STANDARD"

  labels = {
    environment = "test"
    managed_by  = "terraform"
  }
}
