variable "bucket_name" {
  description = "Globally unique GCS bucket name."
  type        = string
}

variable "bucket_location" {
  description = "GCS location, e.g. US or EU."
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "GCS storage class, e.g. STANDARD."
  type        = string
  default     = "STANDARD"
}

variable "labels" {
  description = "User-defined labels to attach to the bucket."
  type        = map(string)
  default     = {}
}
