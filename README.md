terraform-google-vertexai-with-wif
==================================

Terraform modules of Google Cloud Vertex AI with Workload Identity Federation

[![CI](https://github.com/dceoy/terraform-google-vertexai-with-wif/actions/workflows/ci.yml/badge.svg)](https://github.com/dceoy/terraform-google-vertexai-with-wif/actions/workflows/ci.yml)

Installation
------------

1.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/terraform-google-vertexai-with-wif.git
    $ cd terraform-google-vertexai-with-wif
    ```

2.  Install [Google Cloud SDK](https://cloud.google.com/sdk/docs) and authenticate.

3.  Install [Terraform](https://www.terraform.io/).

4.  Activate required Google Cloud APIs.

5.  Generates a speculative execution plan. (Optional)

    ```sh
    $ GOOGLE_CLOUD_PROJECT_ID='vertexai'
    $ GOOGLE_CLOUD_REGION='us-central1'
    $ gcloud infra-manager deployments preview terraform-google-vertexai-with-wif \
        --location="${GOOGLE_CLOUD_REGION}" \
        --terraform-working-directory='envs/dev/' \
        --input-values="project_id=${GOOGLE_CLOUD_PROJECT_ID},region=${GOOGLE_CLOUD_REGION}"
    ```

6.  Creates or updates infrastructure.

    ```sh
    $ GOOGLE_CLOUD_PROJECT_ID='vertexai'
    $ GOOGLE_CLOUD_REGION='us-central1'
    $ gcloud infra-manager deployments create terraform-google-vertexai-with-wif \
        --location="${GOOGLE_CLOUD_REGION}" \
        --terraform-working-directory='envs/dev/' \
        --input-values="project_id=${GOOGLE_CLOUD_PROJECT_ID},region=${GOOGLE_CLOUD_REGION}"
    ```
