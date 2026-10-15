# Reusable GCS bucket resource. Provider is configured in the calling root module.
resource "google_storage_bucket" "this" {
  name          = var.bucket_name
  location      = var.bucket_location
  storage_class = var.storage_class

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  labels = var.labels
}
