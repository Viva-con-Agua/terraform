# Viva con Agua Terraform Definitions

This repository contains infrastructure Configuration-as-Code definitions using the [terraform](https://www.terraform.io/) tool.
It defines the resources we have provisioned in the [Hetzner Cloud](https://www.hetzner.com/cloud) while also applying machine-readable labels to them that are then used in other automation tool like ansible ([our ansible repository](https://github.com/Viva-con-Agua/ansible/)).


## Definition Overview

Currently we define the following important resources:

- The `kubernetes-lb` Load-Balancer to handle all our incoming requests
- A small monitoring VServer located outside of germany to monitor our whole infrastructure from the outside
- Auxiliary resources like Firewalls & SSH-Keys that are needed for the above ones
