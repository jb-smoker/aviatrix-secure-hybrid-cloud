# Aviatrix Secure Hybrid Cloud

## Infrastructure Overview

This Terraform module deploys a robust, multi-cloud network infrastructure across AWS, Azure, and GCP. The architecture uses **Aviatrix** transit gateways to establish secure, and scalable cross-cloud connectivity, along with centralized monitoring and management tools.

### Goal

The goal of this infrastructure is to enable businesses to operate a **highly available**, **secure**, and **scalable** multi-cloud environment, which is critical for modern enterprises. By leveraging **Aviatrix** and this integrated network architecture, businesses can:

1. **Reduce Downtime and Increase Resilience**: Multi-cloud architecture mitigates the risk of cloud provider outages by ensuring cross-cloud redundancy. With direct connectivity between AWS, Azure, and GCP, applications can fail over to another cloud if needed, ensuring minimal disruption to business operations.

2. **Centralized Network Management**: Using **Aviatrix CoPilot** and **Controller**, IT teams gain a unified platform for managing multi-cloud networks. This centralization helps businesses monitor traffic, troubleshoot issues, and implement security policies across multiple clouds without needing separate tools for each cloud provider.

3. **Faster Deployment of Services**: By establishing secure, pre-configured communication channels between different clouds, businesses can quickly deploy services in the cloud provider best suited to the task. For example, data analytics can run on GCP while web services are hosted on AWS, without having to re-engineer connectivity each time.

4. **Hybrid and Multi-Cloud Workflows**: Many businesses operate in a hybrid cloud environment, with workloads split between on-premise infrastructure and multiple clouds. This network architecture facilitates secure, low-latency connectivity between regions and clouds, enabling hybrid deployments to function seamlessly.

## Requirements

Before deploying this infrastructure, ensure that you meet the following requirements:

### Cloud Accounts

- **AWS Account**: Necessary for deploying the AWS VPC, internal apps, and the Aviatrix transit gateway.
- **Azure Account**: Required to set up the Azure VNETs, including the Gatus App and Aviatrix transit gateway.
- **GCP Account**: Needed to deploy the GCP VPC and the KVM guest running Aviatrix Nested Edge and Free Range Routing (FRR).

### Additional Resources

- **QCOW2 File**: A QCOW2 disk image file is required for the KVM guest deployed in the GCP VPC. Ensure you have this file ready before starting the deployment.

### Terraform

- **Terraform Version 1.5.0 or later**: This module requires Terraform 1.5.0 or higher. You can install the latest version from the official Terraform website [here](https://www.terraform.io/downloads.html).

## Topology

The following depicts topology deployed.

![Topology](sp3.png)

## Example terraform code

See [example terraform](example)
