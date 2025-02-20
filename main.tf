terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  allow_unverified_ssl = true
}

# Data Sources
data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Convert string vm_list into structured data
locals {
  raw_vm_list = split("\n", trimspace(var.vm_list))

  parsed_vm_list = [
    for vm in local.raw_vm_list : {
      name    = split(",", vm)[0]
      ip      = split(",", vm)[1]
      netmask = split(",", vm)[2]
      gateway = split(",", vm)[3]
    }
  ]
}

# Create VMs
resource "vsphere_virtual_machine" "vm" {
  for_each         = { for vm in local.parsed_vm_list : vm.name => vm }
  name             = each.value.name
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.pool.id
  folder           = var.vm_folder
  num_cpus         = var.vm_cpu
  memory           = var.vm_memory * 1024 # Convert GB to MB
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  firmware         = data.vsphere_virtual_machine.template.firmware

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = var.vm_disk_size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      dynamic "windows_options" {
        for_each = var.os_type == "windows" ? [1] : []
        content {
          computer_name = each.value.name
        }
      }

      dynamic "linux_options" {
        for_each = var.os_type == "linux" ? [1] : []
        content {
          host_name = each.value.name
          domain    = var.vm_domain
        }
      }

      network_interface {
        ipv4_address = each.value.ip
        ipv4_netmask = each.value.netmask
      }
      ipv4_gateway    = each.value.gateway
      dns_server_list = var.vm_dns_list
      dns_suffix_list = var.vm_suffix_list
    }
  }
}
