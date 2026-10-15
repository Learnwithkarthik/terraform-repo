# Reusable GCS bucket module

This **child module** manages a single Google Cloud Storage bucket.

## Inputs

| Variable | Required | Default | Description |
|---|---|---|---|
| `bucket_name` | Yes | — | Globally unique bucket name |
| `bucket_location` | No | `US` | Bucket location |
| `storage_class` | No | `STANDARD` | Storage class |
| `labels` | No | `{}` | Bucket labels |

## Outputs

- `bucket_name`
- `bucket_url`
- `bucket_location`

## Security baseline

Uniform Bucket-Level Access and Public Access Prevention are enabled. `force_destroy = false` prevents automatic forced deletion of nonempty buckets. These baseline settings are fixed so callers cannot accidentally override them. The **caller** provides the Google provider configuration, allowing this module to be used in different GCP projects.

## Local caller example

```hcl
module "gcs_bucket" {
  source          = "../../modules/gcs-bucket"
  bucket_name     = "dsu-dev-example-unique"
  bucket_location = "US"
  labels          = { environment = "dev" }
}
```

## GitHub source example

```hcl
module "gcs_bucket" {
  source      = "git::https://github.com/OWNER/REPOSITORY.git//modules/gcs-bucket?ref=v1.0.0"
  bucket_name = "dsu-demo-example-unique"
}
```

The tag must exist in the actual repository. Do not put credentials in module source strings.
