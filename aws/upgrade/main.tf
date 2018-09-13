variable "ssh_public_key_file" {
  description = "File where your public key lives"
}

# Set ssh_public_key_file to empty string since we are using ssh_public_key instead
module "dcos" {
  source              = "dcos-terraform/dcos/aws"
  version             = "~> 0.0"

  cluster_name        = "dcos-cluster-upgrade"
  ssh_public_key_file = "${var.ssh_public_key_file}"
  #dcos_version        = "ADD_YOUR_DESIRED_VERSION_HERE"
  #dcos_install_mode   = "upgrade"
  dcos_type           = "open"
  
  num_masters         = "3"
  num_private_agents  = "2"
  num_public_agents   = "1" 

}

# Display the outout of the LB address and public LB to the DC/OS UI
output "cluster-address" {
  value = "${module.dcos.masters-loadbalancer}"
}

