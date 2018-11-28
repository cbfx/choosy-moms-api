# choosy-moms-api
A complex set of quickly zipped lambdas that are uploaded to AWS and tied together
in an API Gateway resource via a rendered swagger api file.

## Pre-installation
This API requires a lot of dependencies.

- "jq": "latest"
- "terraform": "0.11.10"

Additionally, in order to properly run terraform and provision any infrastructure,
you'll certainly want to ensure you have at least the default credentials in your
aws credentials file. If you aren't familiar with the aws cli, [this](https://aws.amazon.com/cli/)
may help.

The method of installation is up to you. There may be a few more that I can't recall.

## Installation
Strangely enough, there's not really a good way to "install" these lambdas locally
unless you set up a SAM environment. This is not very well supported yet (by me)
because SAM prefers CloudFormation and I prefer Terraform. If you want to check
out SAM, read more [here](https://github.com/awslabs/serverless-application-model).

## Testing
This setup of infrastructure is highly experimental and does not have tests
written or running. As the file structure changes and as things evolve, tests
will be factored in.

## Infrastructure and deployment
This UI utilizes an external module that deploys a series of resources in AWS
which allow the UI asset files, once minified, to be placed into an S3 bucket
behind a CloudFront distribution. This distribution can configure origins with
cache behaviors that allow for proxy behavior.

See the terraform variables file for more info on running Terraform.

Here's an example:
```
terraform workspace [select|new] cbfx

terraform plan -var "stage=cbfx" \
  -var "giphy_api_key=12345" \
  -out=tf.tfplan

terraform apply tf.tfplan
```

### Stages

#### Pull requests
https://cbfx-api.gif.cbfx.net
https://cbfx-login.gif.cbfx.net

#### Master merge
https://staging-api.gif.cbfx.net
https://staging-login.gif.cbfx.net

#### Semantic version bump
https://api.gif.cbfx.net
https://login.gif.cbfx.net

* As a side note: This infrastructure is heavily tied to a deployment domain
that you, as a friendly user, will certainly not have as a hosted zone in your
aws account. Ensure that you go through the .circleci/config.yml file to replace
existing references.

## Versioning

CircleCI is listening to any semantic version tags on the repo. There is a
script in this repo that will be run after any `npm` semantic version update.
This script will commit the change to the repo, format a nice commit message,
and then finally push the new tag into Github.

- `npm version patch`
- `npm version minor`
- `npm version major`
- etc
