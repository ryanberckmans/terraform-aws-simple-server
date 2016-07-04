# terraform-aws-simple-server

Example [Terraform](https://www.terraform.io/) configuration to create a single ec2 server with a public ip, ssh, and ping.

# Setup

1. `brew cask install terraform`
1. create an AWS account
1. create [`~/.aws/credentials`](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) from AWS IAM User guide. [Don't use root/master access keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html) from your AWS account; use keys for an IAM user which is assigned to an IAM group which has a policy to do these actions.
4. create a local ssh key using `ssh-keygen` if you haven't already

# Run

1. `git clone git@github.com:ryanberckmans/terraform-aws-simple-server.git`
1. `cd terraform-aws-simple-server`
1. ``TF_VAR_public_server_ssh_public_key=`cat ~/.ssh/id_rsa.pub` terraform plan``
1. to actually create the server replace `plan` with `apply`

# Verify

Note: may take up to 60 seconds after `terraform apply` completes for server to respond to ping/ssh.

1. `ping <elastic ip>` where elastic ip is output by terraform apply
1. `ssh ubuntu@<elastic ip>`
1. open AWS Management Console, set region to us-east, check out EC2 instances, key pair, elastic ip, security group

# destroy so you don't continue to get billed

1. `terraform destroy` // it will ask you for a value for public_server_ssh_public_key, doesn't matter what you put

# License

MIT
