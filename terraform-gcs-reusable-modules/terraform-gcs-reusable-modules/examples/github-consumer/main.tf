# BEFORE RUNNING: replace YOUR_USERNAME and YOUR_REPOSITORY with your GitHub values.
# Also create/push the v1.0.0 Git tag, so Terraform can download the module.
module "gcs_bucket" {
  source = "git::https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git//modules/gcs-bucket?ref=v1.0.0"

  bucket_name     = "dsu-github-${var.project_id}"
  bucket_location = "US"
  storage_class   = "STANDARD"

  labels = {
    environment = "github-demo"
    managed_by  = "terraform"
  }
}
