# Custom DC/OS Cluster Configs
In this example we will create an DC/OS cluster with additional [Cluster Configs](https://docs.mesosphere.com/1.11/installing/production/advanced-configuration/configuration-reference/). In this example we will add the variables for the config arguments directly into the `main.tf` file. Please see the available [Inputs](https://github.com/dcos-terraform/terraform-aws-dcos#inputs) for available arguments that there format. Also see official DC/OS Docs for further explaination or arguments etc. 

# [`main.tf`](./main.tf?raw=1)
Just do an copy of [`main.tf`](./main.tf?raw=1) in a local folder and `cd` into it. 


# `cluster.tfvars`
For this cluster we need to set your ssh public key..

if you already have a ssh key. Just read the public key content and assign it to the terraform variable. Also you should set a cluster name. It gets tagged with this name so you can easily identify the nodes of your cluster.

## Requiered Variables
- `ssh_public_key` SSH public key to be used for deploying the cluster.
- `cluster_name` Defines the OS of all the instances. Select from list below.


## Suggested commands

```bash
$ terraform init
# Add SSH key to vars file
$ echo "ssh_public_key=\"$(cat ~/.ssh/id_rsa.pub)\"" >> cluster.tfvars
# Add the desired version from above
$ echo "cluster_name=\"my-cluster\"" >> cluster.tfvars
# we at mesosphere have to tag our instances with an owner and an expire date.
$ echo "tags={Owner = \"$(whoami)\", Expires = \"2h\"}" >> cluster.tfvars
```

## Adding Configuration Parameters
Inject the individual desired cluster configuration parameters from the [Inputs](https://github.com/dcos-terraform/terraform-aws-dcos#inputs) into the `main.tf` as variables. Please see the example below for `dcos_docker_remove_delay` and `dcos_enable_docker_gc`:

```hcl
variable "ssh_public_key" {
  description = <<EOF
Specify a SSH public key in authorized keys format (e.g. "ssh-rsa ..") to be used with the instances. Make sure you added this key to your ssh-agent
EOF
}

variable "cluster_name" {
  description "Name of your DC/OS Cluster"  
}


/////////////// END VARIABLES //////////////

module "dcos" {
  source  = "dcos-terraform/dcos/aws"
  version = "~> 0.0"

  cluster_name = "${var.cluster_name}"
  ssh_public_key = "${var.ssh_public_key}"

  num_masters = "3"
  num_private_agents = "3"
  num_public_agents = "1"

  dcos_type = "open"
  
  /*
  BEGIN HERE for DC/OS Cluster Configs. See Inputs: https://github.com/dcos-terraform/terraform-aws-dcos#inputs
  Offical Configs Docs: https://docs.mesosphere.com/1.11/installing/production/advanced-configuration/configuration-reference/
  Example Configs below:
  */
  
  # Remove stale docker images after this time
  dcos_docker_remove_delay = "2hrs"

  # Run docker-gc
  dcos_enable_docker_gc = "true"
}

/////////////// OUTPUT //////////////
output "cluster-address" {
  value = "${module.dcos.masters-loadbalancer}"
}
```

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