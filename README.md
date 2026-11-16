# Azure Base Network Infrastructure 

This repository contains Terraform configuration to provision a foundational Azure network architecture. 

## Architecture Overview
This code deploys the following resources in the `Central-India` region:
* **Resource Group:** `Demo-RG1`
* **Virtual Network:** `Demo-VNet1` (Address Space: `10.0.0.0/16`)
  * **Subnet 1:** `VNG1` (`10.0.1.0/24`) - Associated with NSG.
  * **Subnet 2:** `VNG2` (`10.0.2.0/24`)
* **Network Security Group (NSG):** `Demo-NSG1` (Attached to `VNG1`)

## Prerequisites
* [Terraform](https://www.terraform.io/downloads.html) installed locally.
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and authenticated.
* An active Azure Subscription.

## Usage

1. **Authenticate with Azure:**
   ```bash
   az login