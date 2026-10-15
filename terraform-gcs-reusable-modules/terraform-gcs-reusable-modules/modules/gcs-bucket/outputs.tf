output "bucket_name" {
  description = "Created bucket name."
  value       = google_storage_bucket.this.name
}

output "bucket_url" {
  description = "GCS bucket URL (gs://...)."
  value       = google_storage_bucket.this.url
}

output "bucket_location" {
  description = "Created bucket location."
  value       = google_storage_bucket.this.location
}
