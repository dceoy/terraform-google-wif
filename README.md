# terraform-google-wif

Terraform modules of Google Cloud Workload Identity Federation for AWS and GitHub Actions.

[![CI](https://github.com/dceoy/terraform-google-wif/actions/workflows/ci.yml/badge.svg)](https://github.com/dceoy/terraform-google-wif/actions/workflows/ci.yml)

## Installation

1.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/terraform-google-wif.git
    $ cd terraform-google-wif
    ```

2.  Install [Google Cloud SDK](https://cloud.google.com/sdk/docs) and authenticate.

3.  Install [Terraform](https://www.terraform.io/).

4.  Activate required Google Cloud APIs.

5.  Create a Google Cloud service account for Infra Manager.

    ```sh
    $ SYSTEM_NAME='gai'
    $ ENV_TYPE='dev'
    $ PROJECT_ID="my-gcp-project-id"
    $ LOCATION='us-west1'
    $ SERVICE_ACCOUNT_ID='my-infra-manager-sa'
    $ gcloud iam service-accounts create "${SERVICE_ACCOUNT_ID}" \
        --project="${PROJECT_ID}" \
        --display-name="${SERVICE_ACCOUNT_ID}"
    $ gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
        --role='roles/config.admin'
    $ gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
        --role='roles/storage.admin'
    $ gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
        --role='roles/serviceusage.serviceUsageAdmin'
    $ gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
        --role='roles/iam.workloadIdentityPoolAdmin'
    $ gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
        --role='roles/iam.serviceAccountAdmin'
    $ gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
        --role='roles/resourcemanager.projectIamAdmin'
    $ gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
        --role='roles/logging.admin'
    $ gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
        --role='roles/cloudkms.admin'
    ```

6.  Create `envs/dev/terraform.tfvars` and set the variables as follows:

    ```hcl
    system_name       = "gai"
    env_type          = "dev"
    aws_account_id    = "123456789012"
    aws_iam_role_name = "my-iam-role"
    github_repository = "my-github-username/my-repo"
    project_id        = "my-gcp-project-id"
    region            = "us-central1"

    # Optional: Google Cloud budget alert with Slack notifications
    billing_account      = "XXXXXX-XXXXXX-XXXXXX"
    budget_amount        = 100
    budget_currency_code = "USD"
    slack_channel_name   = "#gcp-budget-alerts"
    slack_auth_token     = "xoxb-your-slack-oauth-token"
    ```

    The budget alert fires at 50%, 80%, and 100% of current spend and at 100% of forecasted spend.
    Omit `billing_account`/`budget_amount` to skip creating the budget, and omit
    `slack_channel_name`/`slack_auth_token` to skip the Slack notification channel
    (the budget will still notify default billing administrators).

7.  Create a preview.

    ```sh
    $ PREVIEW_ID='my-preview-id'
    $ gcloud infra-manager previews create \
        "projects/${PROJECT_ID}/locations/${LOCATION}/previews/${PREVIEW_ID}" \
        --service-account="projects/${PROJECT_ID}/serviceAccounts/${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
        --inputs-file="envs/${ENV_TYPE}/terraform.tfvars" \
        --local-source='modules/wif'
    $ gcloud infra-manager previews describe \
        "projects/${PROJECT_ID}/locations/${LOCATION}/previews/${PREVIEW_ID}"
    $ gcloud infra-manager previews delete \
        "projects/${PROJECT_ID}/locations/${LOCATION}/previews/${PREVIEW_ID}"
    ```

8.  Create or update a deployment.

    ```sh
    $ DEPLOYMENT_ID='my-deployment-id'
    $ gcloud infra-manager deployments apply \
        "projects/${PROJECT_ID}/locations/${LOCATION}/deployments/${DEPLOYMENT_ID}" \
        --service-account="projects/${PROJECT_ID}/serviceAccounts/${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
        --inputs-file="envs/${ENV_TYPE}/terraform.tfvars" \
        --import-existing-resources \
        --local-source='modules/wif'
    $ gcloud infra-manager deployments describe \
        "projects/${PROJECT_ID}/locations/${LOCATION}/deployments/${DEPLOYMENT_ID}"
    ```

## Cleanup

```sh
$ PROJECT_ID='my-gcp-project-id'
$ LOCATION='us-central1'
$ DEPLOYMENT_ID='my-deployment-id'
$ gcloud infra-manager deployments delete \
    "projects/${PROJECT_ID}/locations/${LOCATION}/deployments/${DEPLOYMENT_ID}"
```
