terraform-google-wif
====================

Terraform modules of Google Cloud Workload Identity Federation for AWS and GitHub Actions.

[![CI](https://github.com/dceoy/terraform-google-wif/actions/workflows/ci.yml/badge.svg)](https://github.com/dceoy/terraform-google-wif/actions/workflows/ci.yml)

Installation
------------

1.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/terraform-google-wif.git
    $ cd terraform-google-wif
    ```

2.  Install [Google Cloud SDK](https://cloud.google.com/sdk/docs) and authenticate.

3.  Install [Terraform](https://www.terraform.io/).

4.  Activate required Google Cloud APIs.

5.  Create `envs/dev/terraform.tfvars` and set the variables as follows:

    ```hcl
    system_name       = "gai"
    env_type          = "dev"
    aws_account_id    = "123456789012"
    aws_iam_role_name = "my-iam-role"
    github_repository = "my-github-username/my-repo"
    ```

6.  Create a preview.

    ```sh
    $ PROJECT_ID='my-gcp-project-id'
    $ LOCATION='us-central1'
    $ PREVIEW_ID='my-preview-id'
    $ gcloud infra-manager previews create \
        "projects/${PROJECT_ID}/locations/${LOCATION}/previews/${PREVIEW_ID}" \
        --local-source='envs/dev'
    $ gcloud infra-manager previews describe \
        "projects/${PROJECT_ID}/locations/${LOCATION}/previews/${PREVIEW_ID}"
    $ gcloud infra-manager previews delete \
        "projects/${PROJECT_ID}/locations/${LOCATION}/previews/${PREVIEW_ID}"
    ```

7.  Create or update a deployment.

    ```sh
    $ PROJECT_ID='my-gcp-project-id'
    $ LOCATION='us-central1'
    $ DEPLOYMENT_ID='my-deployment-id'
    $ gcloud infra-manager deployments apply \
        "projects/${PROJECT_ID}/locations/${LOCATION}/deployments/${DEPLOYMENT_ID}" \
        --local-source='envs/dev'
    $ gcloud infra-manager deployments describe \
        "projects/${PROJECT_ID}/locations/${LOCATION}/deployments/${DEPLOYMENT_ID}"
    ```

Cleanup
-------

```sh
$ PROJECT_ID='my-gcp-project-id'
$ LOCATION='us-central1'
$ DEPLOYMENT_ID='my-deployment-id'
$ gcloud infra-manager deployments delete \
    "projects/${PROJECT_ID}/locations/${LOCATION}/deployments/${DEPLOYMENT_ID}"
```
