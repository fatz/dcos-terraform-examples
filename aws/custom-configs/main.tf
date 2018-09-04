///////////////// VARIABLES /////////////////
variable "ssh_public_key" {
  description = <<EOF
Specify a SSH public key in authorized keys format (e.g. "ssh-rsa ..") to be used with the instances. Make sure you added this key to your ssh-agent
EOF
}

variable "cluster_name" {
  description = "Name of your DC/OS Cluster"  
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
  BEGIN HERE DC/OS Cluster Configs. See Inputs: https://github.com/dcos-terraform/terraform-aws-dcos#inputs
  Offical Configs Docs: https://docs.mesosphere.com/1.11/installing/production/advanced-configuration/configuration-reference/
  Example Configs:
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