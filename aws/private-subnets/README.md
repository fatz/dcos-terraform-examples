# Create a DC/OS Cluster using an existing VPC and Private Subnets
In this example we will create an DC/OS cluster using an already existing VPC which uses Private Subnets. The `main.tf` file in this repository is our example implementation using a VPC with Private Subnets. In this example we do not allow any Public IP address associtation with any resource.

# [`main.tf`](./main.tf?raw=1)
Just do an copy of [`main.tf`](./main.tf?raw=1) in a local folder and `cd` into it. 

* NOTE: 

# `cluster.tfvars`
For this cluster we need to set your ssh public key..

if you already have a ssh key. Just read the public key content and assign it to the terraform variable. Also you should set a cluster name. It gets tagged with this name so you can easily identify the nodes of your cluster.

## Requiered Variables
- `admin_ips` List of CIDR addresses who get access to the cluster.
- `ssh_public_key` SSH public key to be used for deploying the cluster.

## Suggested commands

```bash
$ terraform init
# Add SSH key to vars file
$ echo "ssh_public_key=\"$(cat ~/.ssh/id_rsa.pub)\"" >> cluster.tfvars
# Set the Subnet of where connections to the Cluster will be made (Your Local Subnet)
$ echo "admin_ips=[\"1.2.3.0/24\", \"3.2.1.0/24\"]" >> cluster.tfvars
# we at mesosphere have to tag our instances with an owner and an expire date.
$ echo "tags={Owner = \"$(whoami)\", Expires = \"2h\"}" >> cluster.tfvars
```

## Setting VPC/Subnets
Out of the box, this example uses the default VPC and all of the subnets from that VPC. You may modify these entries to specific "id" or by using Tags to specify. Examples are commented our in the main.tf. See example below for using tags:

```bash
# instead of default you could specify an ID or Tags. 
# https://www.terraform.io/docs/providers/aws/d/vpc.html
data "aws_vpc" "default" {
  provider = "aws"

  default = false # or false if not default and use either id or tags below
  #id = ""        # If false you can use specific ID of VPC OR use tags 
  tags {
    Name = "test-private-vpc"
  }
}

# You could use tags if you only want a subset of subnets such as a subnet with only Private Subnet
# https://www.terraform.io/docs/providers/aws/d/subnet_ids.html
data "aws_subnet_ids" "default_subnets" {
  provider = "aws"

  vpc_id = "${data.aws_vpc.default.id}" 
  #id = "[]"        # You can use the Specific ID(s) OR use tags
  tags {
    Name = "test-private-vpc-subnet"
  }
}
```

## Local Variables
We've added intermediate local variables for all module output and inputs. This will make it easy replacing parts of the modules with your own code.

# AWS
DC/OS Terraform is using the [AWS Default Credentials Chain](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html). To change REGION or Account you can use the [AWS Environment Variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html)

## Change region (optional)
Changing the default region ( the one you specified with `aws configure` )

```bash
# Change the default region to us-east-1
$ export AWS_DEFAULT_REGION="us-east-1" 
```

## Change profile (optional)
If you want to use a second profile for deploying you can use `AWS_PROFILE` variable

```bash
$ export AWS_PROFILE=my-second-profile
```

# terraform init
Doing terraform init lets terraform download all the needed modules to spawn DC/OS Cluster on AWS

```bash
$ terraform init
```

# terraform plan
We expect your aws environment is properly setup. Check it with issuing `aws sts get-caller-identity`.

We now create the terraform plan which gets applied later on.

```bash
$ terraform plan --var-file cluster.tfvars -out=cluster.plan
```

# terraform apply
Now we're applying our plan

```bash
$ terraform apply "cluster.plan"
```

in the output section you will find the hostname of your cluster. With this hostname you'll be able to access the cluster.

# terraform destroy
If you want to destroy your cluster again use

```bash
$ terraform destroy --var-file cluster.tfvars
```