# Aviatrix Secure Hybrid Cloud

## Infrastructure Overview

This Terraform module deploys a multi-cloud network infrastructure spanning AWS, Azure, and GCP. The architecture includes the following components:

1. **Azure**:
   - An Azure Virtual Network (VNET) with a **Gatus App** that performs ICMP checks to Free Range Routing (FRR).
   - Another Azure VNET that contains Aviatrix transit gateways for establishing connections with AWS and GCP.

2. **AWS**:
   - An AWS Virtual Private Cloud (VPC) that hosts internal applications.
   - A Virtual Network Gateway (VNG) with a site-to-cloud (S2C) connection to Azure.

3. **VNET Peering**:
   - Peering between Azure VNETs to allow communication between the Gatus App and other Azure services.

4. **Multi-Cloud Transit Network**:
   - Aviatrix transit gateways in both Azure and AWS regions.
   - The gateways are connected through the internet to a GCP VPC, which hosts a KVM guest running Aviatrix Nested Edge and FRR.

5. **Management VPC/VNET**:
   - Aviatrix CoPilot and Aviatrix Controller are deployed for centralized management and monitoring of the cloud network infrastructure.

The network is fully integrated across three major cloud providers (AWS, Azure, GCP), using Aviatrix transit gateways to establish connectivity and ensuring redundancy and high availability through multiple routes.

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
