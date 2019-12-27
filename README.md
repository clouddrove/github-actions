
<h1 align="center">
    Github Actions
</h1>

<p align="center" style="font-size: 1.2rem;">
    GitHub Actions allow you to execute Terraform commands within GitHub Actions.
     </p>

<p align="center">

</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-aws-vpc'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+VPC&url=https://github.com/clouddrove/terraform-aws-vpc'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AWS+VPC&url=https://github.com/clouddrove/terraform-aws-vpc'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>

## Usage

### terraform and terratest
The most common workflow is to run `terratest` `terraform fmt`, `terraform init`, `terraform validate`, and `terraform plan` on all of the Terraform files in the root of the repository when a pull request is opened or updated. A comment will be posted to the pull request depending on the output of the Terraform subcommand being executed. This workflow can be configured by adding the following content to the GitHub Actions workflow YAML file.

```yaml
name: 'Terraform GitHub Actions'
on:
  - pull_request

jobs:
  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest
    steps:

      - name: 'Checkout'
        uses: actions/checkout@master

      - name: 'Terraform Format'
        uses: clouddrove/github-actions@master
        with:
          actions_subcommand: 'fmt'

      - name: 'Terraform Init fot public-private-subnet'
        uses: clouddrove/github-actions@master
        with:
          actions_subcommand: 'init'
          tf_actions_working_dir: ./_example/public-private-subnet    
      
      - name: Configure AWS Credentials
        uses: clouddrove/configure-aws-credentials@v1
        with:
         aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
         aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
         aws-region: us-east-2      
     
      - name: 'Terraform Plan For public-private-subnet'
        uses: clouddrove/github-actions@master
        with:
          actions_subcommand: 'plan'
          tf_actions_working_dir: ./_example/public-private-subnet
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: 'Terratest For public-private-subnet'
        uses: clouddrove/github-actions@master
        with:
          actions_subcommand: 'terratest'
          tf_actions_working_dir: ./_test/public-private-subnet
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: 'Terratest For public-subnet'
        uses: clouddrove/github-actions@master
        with:
          actions_subcommand: 'terratest'
          tf_actions_working_dir: ./_test/public-subnet
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}


      - name: 'Slack Notification'
        uses: clouddrove/action-slack@v2
        with:
          status: ${{ job.status }}
          fields: repo,author
          author_name: 'Clouddrove'
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} # required
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }} # required
        if: always()
```

This was a simplified example showing the basic features of these Terraform GitHub Actions. Please refer to the examples within the `examples` directory for other common workflows.

## Inputs

Inputs configure Terraform GitHub Actions to perform different actions.

* `actions_subcommand` - (Required) The Terraform subcommand to execute. Valid values are `terratest` `fmt`, `init`, `validate`, `plan`, and `apply`.
* `tf_actions_version` - (Required) The Terraform version to install and execute.
* `tf_actions_cli_credentials_hostname` - (Optional) Hostname for the CLI credentials file. Defaults to `app.terraform.io`.
* `tf_actions_cli_credentials_token` - (Optional) Token for the CLI credentials file.
* `tf_actions_comment` - (Optional) Whether or not to comment on GitHub pull requests. Defaults to `true`.
* `tf_actions_working_dir` - (Optional) The working directory to change into before executing Terraform subcommands. Defaults to `.` which means use the root of the GitHub repository.
* `terratest` - (Optional) If you want to run `terratest` of terraform module.

## Outputs

Outputs are used to pass information to subsequent GitHub Actions steps.

* `tf_actions_output` - The Terraform outputs in JSON format.
* `tf_actions_plan_has_changes` - Whether or not the Terraform plan contained changes.

## Secrets

Secrets are similar to inputs except that they are encrypted and only used by GitHub Actions. It's a convenient way to keep sensitive data out of the GitHub Actions workflow YAML file.

* `GITHUB_TOKEN` - (Optional) The GitHub API token used to post comments to pull requests. Not required if the `tf_actions_comment` input is set to `false`.

Other secrets may be needed to authenticate with Terraform backends and providers.

**WARNING:** These secrets could be exposed if the action is executed on a malicious Terraform file. To avoid this, it is recommended not to use these Terraform GitHub Actions on repositories where untrusted users can submit pull requests.

## Feedback
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-aws-vpc/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a * on [our GitHub](https://github.com/clouddrove/github-actions)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=