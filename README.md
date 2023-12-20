# Viva con Agua Terraform Definitions

This repository contains infrastructure Configuration-as-Code definitions using the [terraform](https://www.terraform.io/) tool.
It defines the resources we have provisioned in the [Hetzner Cloud](https://www.hetzner.com/cloud) while also applying machine-readable labels to them that are then used in other automation tool like ansible ([our ansible repository](https://github.com/Viva-con-Agua/ansible/)).


## Definition Overview

Currently we define the following important resources:

- The `kubernetes-lb` Load-Balancer to handle all our incoming requests
- A small monitoring VServer located outside of germany to monitor our whole infrastructure from the outside
- Auxiliary resources like Firewalls & SSH-Keys that are needed for the above ones

We also apply the following labels to our servers:

- `vivaconagua.org/purpose`: A human readble description of what this server does
- `vivaconagua.org/public_dns`: The public DNS record which points to this server.
  It should be the same as the servers reverse dns records and is used by other tools to establish a connection to this server.
- `vivaconagua.org/firewall`: Determines which hetzner firewall should be applied to the server.

## Repo Structure

```text
terraform
├─ resources/          (static resource files (or templates) loaded into .tf definitions)
├─ resources.tf        (terraform definitions for the content of the resources/ directory)
├─ providers.tf        (general terraform configuration and dependency specification)
├─ hcloud_general.tf   (general hetzner resources used everywhere)
├─ firewalls.tf        (hetzner firewall rules)
├─ srv_*.tf            (v-server definitions)
├─ lb_*.tf             (load-balancer definitions)
…                      (terraform internal state-keeping files)
```

## Usage

The terraform configuration can be applied using

```shell
terraform apply
```

### Server Creation

To add a new server, create a new `srv_<server_name>.tf` file.
This invlude terraform definitions to create the new server (including its reverse dns entries).

The following conventions should be kept in mind

- The name in Hetzner should be the servers fully qualified domain name.
- Appropriate labels should be applied.
- The server should be initialized using cloud-init so that ansible can take over later.

### User Account Creation

Most server configuration is done via ansible but we use cloud-init to provision a bare-bones server environment in which ansible can work easily.
This includes creating some user accounts which of course need some data.

To instruct terraform to create more linux accounts on server creation the following steps need to be performed:

1. The users public key file should be placed in the `resources/users/` directory.
2. The users password hash should be placed in the `resources/users/` directory.
   A new hash can be generated using the `mkpasswd` cli tool on linux.
3. A `hcloud_ssh_key` resource should be created to upload the ssh key to hetzner.
   This is done in the [hcloud_general.tf](./hcloud_general.tf) file.
4. Context variables need to be given to the cloud-init template containing the new users public key and password hash.
   This is done in the [hcloud_general.tf](./hcloud_general.tf) file via the `cloud-init-config` resource.
5. Cloud-init must be configured to create the new user account on server creation.
   To do so, create a new user definition in [resources/cloud-config.yml](./resources/cloud-config.yml).
