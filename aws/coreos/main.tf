///////////////// VARIABLES /////////////////
variable "ssh_public_key" {
  description = <<EOF
Specify a SSH public key in authorized keys format (e.g. "ssh-rsa ..") to be used with the instances. Make sure you added this key to your ssh-agent
EOF
}

variable "dcos_instance_os" {
  description = "Version of Container Linux we are going to use"
}

/////////////// END VARIABLES //////////////

module "dcos" {
  source  = "dcos-terraform/dcos/aws"
  version = "~> 0.0"

  cluster_name = "coreos-cluster"
  ssh_public_key = "${var.ssh_public_key}"

  num_masters = "3"
  num_private_agents = "7"
  num_public_agents = "1"

  dcos_type = "open"
  dcos_instance_os = "${var.dcos_instance_os}"
  dcos_version = "1.11.4"
  dcos_install_mode = "install"
  
  # dcos_license_key_contents = ""
}

/////////////// OUTPUT //////////////
output "cluster-address" {
  value = "${module.dcos.masters-loadbalancer}"
}