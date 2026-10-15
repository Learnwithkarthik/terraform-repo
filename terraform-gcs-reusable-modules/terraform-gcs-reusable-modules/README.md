# Terraform GCS reusable module — GitHub classroom lab

A ready-to-upload Terraform repository that demonstrates **one reusable GCS bucket module** consumed by separate `dev`, `test`, and `prod` root configurations, plus an example that consumes the same module from **GitHub using a Git tag**.

## Repository layout

```text
terraform-gcs-reusable-modules/
├── .gitignore
├── README.md
├── modules/
│   └── gcs-bucket/
│       ├── versions.tf       # Module provider requirements
│       ├── main.tf           # Reusable bucket resource
│       ├── variables.tf      # Module inputs
│       ├── outputs.tf        # Module outputs
│       └── README.md
├── environments/
│   ├── dev/                  # Separate Terraform root/state
│   ├── test/                 # Separate Terraform root/state
│   └── prod/                 # Separate Terraform root/state
└── examples/
    └── github-consumer/     # Fetches module from pinned GitHub tag
```

Every root (`environments/*` and `examples/github-consumer`) contains `versions.tf`, `provider.tf`, `variables.tf`, `main.tf`, `outputs.tf`, and `terraform.tfvars.example`.

## What is reusable?

The **child module** at `modules/gcs-bucket` defines the Google Cloud Storage resource once. Its inputs are `bucket_name`, `bucket_location`, `storage_class`, and `labels`. It enforces Uniform Bucket-Level Access and Public Access Prevention, and sets `force_destroy = false`.

Each **root module** supplies different inputs, configures the Google provider, and manages its own Terraform state. The roots do **not** share state automatically.

## Requirements

- Terraform CLI and Google Cloud SDK installed, or use Google Cloud Shell.
- An existing GCP project with Cloud Storage API enabled.
- Credentials with permissions to create and manage GCS buckets.
- Bucket names must be **globally unique**; the examples include your project ID in each name.
- Internet access to download the Google Terraform provider. The GitHub consumer also needs Git access to your repository.

### 1. Upload these files to your existing GitHub repository

Extract the ZIP and copy **its contents**, preserving the `modules/`, `environments/`, and `examples/` directories, into your existing repository checkout.

```bash
git add .
git commit -m "Add reusable Terraform GCS module and environment examples"
git push origin main
```

If your default branch is not `main`, use its actual name. If you are starting a new repository, create it in GitHub, clone it, then copy these files into the clone. Do not upload the ZIP as a single GitHub file if you want Terraform to use the module files — **extract it first**.

> You can also upload extracted files through GitHub's **Add file → Upload files** interface. Preserve the directory structure (the Git command-line workflow is more reliable for folders).

### 2. Run the DEV example (local module)

From the repository root:

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with **your actual GCP project ID**:

```hcl
project_id = "my-actual-gcp-project-id"
```

Authenticate if necessary (for example, on your own Ubuntu server):

```bash
gcloud auth application-default login
```

In Google Cloud Shell you can normally use its existing credentials. Enable the API in your selected project if needed:

```bash
gcloud services enable storage.googleapis.com --project=MY_PROJECT_ID
```

Run:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform state list
terraform output
```

The bucket resource address is:

```text
module.gcs_bucket.google_storage_bucket.this
```

The module is referenced with:

```hcl
source = "../../modules/gcs-bucket"
```

### 3. Reuse the same module for TEST and PROD

From repository root, repeat in `environments/test` and then `environments/prod`:

```bash
cd environments/test
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your GCP project ID.
terraform init
terraform plan
terraform apply
```

Run each directory **independently**. All three roots call the same module but use different bucket names and labels (the TEST example also chooses `EU` location).

> The `prod` folder is only a classroom example. Do not point it at an actual production project without review, approvals, and a remote state backend.

### 4. Publish a version in GitHub

From the repository root after committing/pushing your module:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Git tags identify the exact module code you want consumers to use. Make new tags for future changes rather than moving existing tags.

### 5. Consume the module directly from GitHub

Open:

```text
examples/github-consumer/main.tf
```

Replace both `YOUR_USERNAME` and `YOUR_REPOSITORY` in the module's source URL with your actual GitHub owner/repository. The source must look like:

```hcl
source = "git::https://github.com/OWNER/REPOSITORY.git//modules/gcs-bucket?ref=v1.0.0"
```

The `//modules/gcs-bucket` part identifies the module **subdirectory**. `?ref=v1.0.0` selects your Git tag. **The tag must exist on GitHub first**.

Next:

```bash
cd examples/github-consumer
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your GCP project ID.
terraform init
terraform plan
terraform apply
```

Terraform downloads the module into `.terraform/modules/` during initialization. The GitHub example uses a unique bucket name (`dsu-github-...`) so it does not conflict with DEV/TEST/PROD.

**Private repository?** Your Git client must already have appropriate GitHub authentication. Do not embed tokens in `.tf` sources or commit credentials.

### 6. Optional: Switch DEV from local source to GitHub source

After pushing tag `v1.0.0`, change only the `source` line in `environments/dev/main.tf` from the relative folder to your actual tagged GitHub URL. Then run:

```bash
terraform init -upgrade
terraform plan
```

If the module code and inputs are unchanged, Terraform should not recreate the existing bucket. Do **not** start a new state or delete `.tfstate` during the transition.

## When to use each approach

| Scenario | Source | Why |
|---|---|---|
| Developing a module within one repo | `../../modules/gcs-bucket` | Quick, local feedback |
| Reusing module across multiple repositories | Git URL pinned to a tag | Versioned release and controlled upgrades |
| Enterprise use with many teams | Private module registry (optional) | Discoverability, governance, release workflows |

## Safety and cleanup

- **GCS bucket names are globally unique.** Change the names if they conflict.
- GCS charges may apply. Examples create empty buckets; usage and storage could incur charges.
- `force_destroy = false` means Terraform will not force-delete a non-empty bucket.
- Each root uses **local state by default**, suitable for the lab but not a team production deployment. Use separate approved GCS remote backends and locking for collaboration.
- **Never commit** service account JSON keys, Terraform state, private keys, or a sensitive `terraform.tfvars`.
- To remove **one lab's** resources, open that root directory and run `terraform destroy`. Check the plan carefully. Do not destroy important infrastructure.

## Learning checklist

1. Identify the **root module** (for example `environments/dev`).
2. Identify the **child module** (`modules/gcs-bucket`).
3. Trace root input → module variable → resource → module output → root output.
4. Create DEV with local module source.
5. Reuse the module from TEST using a different bucket name/location.
6. Commit and tag the module in GitHub.
7. Run the GitHub consumer with a pinned source.
8. Compare `terraform state list` in each root and observe they manage separate resources.

## References

- https://developer.hashicorp.com/terraform/language/modules/sources
- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
