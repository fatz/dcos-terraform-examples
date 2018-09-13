# DC/OS Cluster Upgrade 
In this example we will upgrade the DC/OS Cluster to a newer version. *** You must already have a cluster created using any of the other DC/OS Terraform methods in order for this to work. We have created a simple way to do cluster upgrades by creating triggers that handle the cluster upgrade for the user by defining 2 variables:

`dcos_version` = `DESIRED_VERSION`

`dcos_install_mode` = `upgrade`

Adding the above variables will then trigger the cluster version upgrade process for all the nodes in the cluster. Please note that you should always have `dcos_install_mode` set to default of `install` unless you are executing an upgrade. 


# [`main.tf`](./main.tf?raw=1)
Add the following variables to your pre-existing `main.tf` or as vars to your variables file.

```bash
# Example for upgrade from 1.11.3 to 1.11.4
dcos_version        = "1.11.4"
dcos_install_mode   = "upgrade"
```

Example:
```hcl
variable "ssh_public_key_file" {
  description = "File where your public key lives"
}

# Set ssh_public_key_file to empty string since we are using ssh_public_key instead
module "dcos" {
  source              = "dcos-terraform/dcos/aws"
  version             = "~> 0.0"

  cluster_name        = "dcos-cluster-upgrade"
  ssh_public_key_file = "~/.ssh/id_rsa.pub"

  dcos_version        = "1.11.4"
  dcos_install_mode   = "upgrade"
  
  dcos_type           = "open"
  
  num_masters         = "3"
  num_private_agents  = "2"
  num_public_agents   = "1" 

}

# Display the outout of the LB address and public LB to the DC/OS UI
output "cluster-address" {
  value = "${module.dcos.masters-loadbalancer}"
}
```

# terraform plan
We now create the terraform plan which gets applied later on. You should see multiple null-resource objects to be performed (bootstrap, masters, agents...). These where triggered based on version and upgrade. 

```bash
$ terraform plan -out=cluster.plan
```
Example output:
```bash
Terraform will perform the following actions:

-/+ module.dcos.module.dcos-install.module.dcos-bootstrap-install.null_resource.bootstrap (new resource required)
      id:                                                    "8432050558130891909" => <computed> (forces new resource)
      triggers.%:                                            "92" => "92"
      triggers.custom_dcos_download_path:                    "" => ""
      triggers.dcos_adminrouter_tls_1_0_enabled:             "" => ""
      triggers.dcos_adminrouter_tls_1_1_enabled:             "" => ""
      triggers.dcos_adminrouter_tls_1_2_enabled:             "" => ""
      triggers.dcos_adminrouter_tls_cipher_suite:            "" => ""
      triggers.dcos_agent_list:                              "" => ""
      triggers.dcos_audit_logging:                           "" => ""
      triggers.dcos_auth_cookie_secure_flag:                 "" => ""
      triggers.dcos_aws_access_key_id:                       "" => ""
      triggers.dcos_aws_region:                              "" => ""
      triggers.dcos_aws_secret_access_key:                   "" => ""
      triggers.dcos_aws_template_storage_access_key_id:      "" => ""
      triggers.dcos_aws_template_storage_bucket:             "" => ""
      triggers.dcos_aws_template_storage_bucket_path:        "" => ""
      triggers.dcos_aws_template_storage_region_name:        "" => ""
      triggers.dcos_aws_template_storage_secret_access_key:  "" => ""
      triggers.dcos_aws_template_upload:                     "" => ""
      triggers.dcos_bootstrap_port:                          "80" => "80"
      triggers.dcos_bouncer_expiration_auth_token_days:      "" => ""
      triggers.dcos_ca_certificate_chain_path:               "" => ""
      triggers.dcos_ca_certificate_key_path:                 "" => ""
      triggers.dcos_ca_certificate_path:                     "" => ""
      triggers.dcos_check_time:                              "" => ""
      triggers.dcos_cluster_docker_credentials:              "" => ""
      triggers.dcos_cluster_docker_credentials_dcos_owned:   "" => ""
      triggers.dcos_cluster_docker_credentials_enabled:      "" => ""
      triggers.dcos_cluster_docker_credentials_write_to_etc: "" => ""
      triggers.dcos_cluster_docker_registry_enabled:         "" => ""
      triggers.dcos_cluster_docker_registry_url:             "" => ""
      triggers.dcos_cluster_name:                            "dcos-cluster-upgrade" => "dcos-cluster-upgrade"
      triggers.dcos_config:                                  "" => ""
      triggers.dcos_custom_checks:                           "" => ""
      triggers.dcos_customer_key:                            "" => ""
      triggers.dcos_dns_bind_ip_blacklist:                   "" => ""
      triggers.dcos_dns_forward_zones:                       "" => ""
      triggers.dcos_dns_search:                              "" => ""
      triggers.dcos_docker_remove_delay:                     "" => "2hrs" (forces new resource)
      triggers.dcos_enable_docker_gc:                        "" => "true" (forces new resource)
      triggers.dcos_enable_gpu_isolation:                    "" => ""
      triggers.dcos_exhibitor_address:                       "" => ""
      triggers.dcos_exhibitor_azure_account_key:             "" => ""
      triggers.dcos_exhibitor_azure_account_name:            "" => ""
      triggers.dcos_exhibitor_azure_prefix:                  "" => ""
      triggers.dcos_exhibitor_explicit_keys:                 "" => ""
      triggers.dcos_exhibitor_storage_backend:               "static" => "static"
      triggers.dcos_exhibitor_zk_hosts:                      "" => ""
      triggers.dcos_exhibitor_zk_path:                       "" => ""
      triggers.dcos_fault_domain_enabled:                    "" => ""
      triggers.dcos_gc_delay:                                "" => ""
      triggers.dcos_gpus_are_scarce:                         "" => ""
      triggers.dcos_http_proxy:                              "" => ""
      triggers.dcos_https_proxy:                             "" => ""
      triggers.dcos_ip_detect_public_filename:               "" => ""
      triggers.dcos_l4lb_enable_ipv6:                        "" => ""
      triggers.dcos_license_key_contents:                    "" => ""
      triggers.dcos_log_directory:                           "" => ""
      triggers.dcos_master_discovery:                        "static" => "static"
      triggers.dcos_master_dns_bindall:                      "" => ""
      triggers.dcos_master_external_loadbalancer:            "" => ""
      triggers.dcos_mesos_container_log_sink:                "" => ""
      triggers.dcos_mesos_dns_set_truncate_bit:              "" => ""
      triggers.dcos_mesos_max_completed_tasks_per_framework: "" => ""
      triggers.dcos_no_proxy:                                "" => ""
      triggers.dcos_num_masters:                             "" => ""
      triggers.dcos_oauth_enabled:                           "" => ""
      triggers.dcos_overlay_config_attempts:                 "" => ""
      triggers.dcos_overlay_enable:                          "" => ""
      triggers.dcos_overlay_mtu:                             "" => ""
      triggers.dcos_overlay_network:                         "" => ""
      triggers.dcos_package_storage_uri:                     "" => ""
      triggers.dcos_previous_version:                        "" => ""
      triggers.dcos_previous_version_master_index:           "0" => "0"
      triggers.dcos_process_timeout:                         "" => ""
      triggers.dcos_public_agent_list:                       "" => ""
      triggers.dcos_resolvers:                               "" => ""
      triggers.dcos_rexray_config:                           "" => ""
      triggers.dcos_rexray_config_filename:                  "" => ""
      triggers.dcos_rexray_config_method:                    "" => ""
      triggers.dcos_s3_bucket:                               "" => ""
      triggers.dcos_s3_prefix:                               "" => ""
      triggers.dcos_security:                                "" => ""
      triggers.dcos_skip_checks:                             "0" => "0"
      triggers.dcos_staged_package_storage_uri:              "" => ""
      triggers.dcos_superuser_password_hash:                 "" => ""
      triggers.dcos_superuser_username:                      "" => ""
      triggers.dcos_telemetry_enabled:                       "" => ""
      triggers.dcos_type:                                    "open" => "open"
      triggers.dcos_ucr_default_bridge_subnet:               "" => ""
      triggers.dcos_use_proxy:                               "" => ""
      triggers.dcos_version:                                 "1.11.3" => "1.11.3"
      triggers.dcos_zk_agent_credentials:                    "" => ""
      triggers.trigger:                                      "" => ""

-/+ module.dcos.module.dcos-install.module.dcos-masters-install.null_resource.master1 (new resource required)
      id:                                                    "1596624165415786191" => <computed> (forces new resource)
      triggers.%:                                            "1" => <computed> (forces new resource)
      triggers.trigger:                                      "8432050558130891909" => "" (forces new resource)

-/+ module.dcos.module.dcos-install.module.dcos-masters-install.null_resource.master2 (new resource required)
      id:                                                    "6709085034033606886" => <computed> (forces new resource)
      triggers.%:                                            "1" => <computed> (forces new resource)
      triggers.dependency_id:                                "1596624165415786191" => "" (forces new resource)

-/+ module.dcos.module.dcos-install.module.dcos-masters-install.null_resource.master3 (new resource required)
      id:                                                    "7327432700340259455" => <computed> (forces new resource)
      triggers.%:                                            "1" => <computed> (forces new resource)
      triggers.dependency_id:                                "6709085034033606886" => "" (forces new resource)

-/+ module.dcos.module.dcos-install.module.dcos-private-agents-install.null_resource.private-agents[0] (new resource required)
      id:                                                    "988738647313692500" => <computed> (forces new resource)
      triggers.%:                                            "1" => <computed> (forces new resource)
      triggers.trigger:                                      "1596624165415786191,6709085034033606886,7327432700340259455" => "" (forces new resource)

-/+ module.dcos.module.dcos-install.module.dcos-private-agents-install.null_resource.private-agents[1] (new resource required)
      id:                                                    "3049499793802567789" => <computed> (forces new resource)
      triggers.%:                                            "1" => <computed> (forces new resource)
      triggers.trigger:                                      "1596624165415786191,6709085034033606886,7327432700340259455" => "" (forces new resource)

-/+ module.dcos.module.dcos-install.module.dcos-public-agents-install.null_resource.public-agents (new resource required)
      id:                                                    "4272335152134009307" => <computed> (forces new resource)
      triggers.%:                                            "1" => <computed> (forces new resource)
      triggers.trigger:                                      "1596624165415786191,6709085034033606886,7327432700340259455" => "" (forces new resource)


Plan: 7 to add, 0 to change, 7 to destroy.

------------------------------------------------------------------------
```

# terraform apply
Now we're applying our plan and the cluster will get upgraded to specified version. 

```bash
$ terraform apply "cluster.plan"
```

# NOTE
Once the cluster is upgraded, in order to support scaling later on, modify the `dcos_install_mode` to `install`. This will ensure that if/when you choose to scale your cluster it will run the install process and not the upgrade process. 

# terraform destroy
If you want to destroy your cluster again use

```bash
$ terraform destroy --var-file cluster.tfvars
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