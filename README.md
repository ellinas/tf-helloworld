# tf-helloworld
Hello world terraform repo (AWS Fargate based), quasi fork of https://github.com/jimmysawczuk/terraform-fargate-tutorial. Full description/rundown at https://section411.com/2019/07/hello-world/.

## Prerequisites
- AWS account and user with programmatic access
- ap-east-1 region enabled in AWS
- Local terraform or other CI/CD setup, with AWS access configured
- your_email and main_region terraform input variables should be set

## Usage
A basic terraform init/plan/apply should suffice for a local setup. For terraform cloud, create a workspace pointing to your repo, configure aws access and input variables and then trigger a run. The setup should be complete in 5 minutes or so, with the ALB URL given as an output to access the application.

## App
The app is a simple GO based web service which outputs the date/time, sunrise, sunset and solar noon info for a given location (this is hardcoded to New York). Two endpoints exist; one is at the root/base URL which performs the aforementioned function, while the other is at /health and simply outputs the current date/time which also serves as a health check for the application.

## Terraform modules
| Module name      | Domain | Description
| ----------- | ----------- |
| config.tf      | Setup/config       | Initial config of terraform/aws, and remote (S3) backend
| ecs.tf   | Infra/compute        | Provisioning and config of the fargate cluster
| network.tf      | Infra/networking       | Provisioning and config of the network used by the fargate cluster
| observability.tf   | Infra/observability        | Provisioning and config of a basic cloudwatch alarm/sns topic for the fargate cluster

## AWS config
Simple user with admin permissions/policy (AdministratorAccess). Access key details fed in as sensitive variables in the terraform cloud workspace.

## CI/CD
Terraform cloud workspace set up, pointing to this repository. Automatic run creation/terraform plan upon code change, with manual confirmation for applies and destroys.

## Monitoring/observability
Simple cloudwatch alarm set up, with a message sent to an SNS topic when no healthy targets exist in the target group. SNS topic configured with an email subscriber, which requires manual confirmation to begin receiving messages.