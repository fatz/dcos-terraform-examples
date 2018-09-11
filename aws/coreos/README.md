# Create a DC/OS Cluster with Container Linux
In this example we will create an DC/OS cluster using Container Linux (formerly CoreOS). All it takes is defining the correct version from the selection below as the dcos_instance_os and it will find the correct AMI based on your region and version of Container Linux. 

# [`main.tf`](./main.tf?raw=1)
Just do an copy of [`main.tf`](./main.tf?raw=1) in a local folder and `cd` into it. 

* NOTE: 

# `cluster.tfvars`
For this cluster we need to set your ssh public key..

if you already have a ssh key. Just read the public key content and assign it to the terraform variable. Also you should set a cluster name. It gets tagged with this name so you can easily identify the nodes of your cluster.

## Requiered Variables
- `ssh_public_key` SSH public key to be used for deploying the cluster.
- `dcos_instance_os` Defines the OS of all the instances. Select from list below.

## Currently offered versions of Container Linux (CoreOS)
These are the currently supported versions for the terraform modules. Please consult the [DC/OS Supported OS matrix](https://docs.mesosphere.com/version-policy/#dcos-platform-version-compatibility-matrix). Please note that this list may be out of date and will continously be updated based on supported OS to version of DC/OS. 

- `coreos_1235.9.0`
- `coreos_1465.8.0`
- `coreos_1576.5.0`
- `coreos_835.13.0`



## Suggested commands

```bash
$ terraform init
# Add SSH key to vars file
$ echo "ssh_public_key=\"$(cat ~/.ssh/id_rsa.pub)\"" >> cluster.tfvars
# Add the desired version from above
$ echo "dcos_instance_os=\"coreos_1235.9.0\"" >> cluster.tfvars
# we at mesosphere have to tag our instances with an owner and an expire date.
$ echo "tags={Owner = \"$(whoami)\", Expires = \"2h\"}" >> cluster.tfvars
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