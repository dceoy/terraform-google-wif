terraform-google-wif
====================

Terraform modules of Workload Identity Federation on Google Cloud

[![CI](https://github.com/dceoy/terraform-google-wif/actions/workflows/ci.yml/badge.svg)](https://github.com/dceoy/terraform-google-wif/actions/workflows/ci.yml)

Installation
------------

1.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/terraform-google-wif.git
    $ cd terraform-google-wif
    ```

2.  Install [Google Cloud SDK](https://cloud.google.com/sdk/docs) and authenticate.

3.  Install [Terraform](https://www.terraform.io/) and [Terragrunt](https://terragrunt.gruntwork.io/).

4.  Activate required Google Cloud APIs.

5.  Initialize Terraform working directories.

    ```sh
    $ terragrunt run-all init --working-dir='envs/dev/' -upgrade -reconfigure
    ```

6.  Generates a speculative execution plan. (Optional)

    ```sh
    $ terragrunt run-all plan --working-dir='envs/dev/'
    ```

7.  Creates or updates infrastructure.

    ```sh
    $ terragrunt run-all apply --working-dir='envs/dev/' --non-interactive
    ```
