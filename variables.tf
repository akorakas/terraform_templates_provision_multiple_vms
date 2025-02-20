variable "vsphere_user" {
  description = "vSphere user"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "vSphere server"
  type        = string
}

variable "datacenter" {
  description = "The name of the datacenter where the VM will be deployed"
  type        = string
}

variable "datastore" {
  description = "The name of the datastore where the VM will be stored"
  type        = string
}

variable "resource_pool" {
  description = "The name of the resource pool for the VM"
  type        = string
}

variable "cluster" {
  description = "The name of the vSphere cluster for the VM"
  type        = string
}

variable "network" {
  description = "Name of the virtual machine network"
  type        = string
}

variable "template" {
  description = "Name of the virtual machine template"
  type        = string
}

variable "vm_cpu" {
  description = "Number of CPUs"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Memory size in GB"
  type        = number
  default     = 4
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 50
}

variable "vm_domain" {
  description = "DNS domain of the virtual machine"
  type        = string
  default     = "gym.lan"
}

variable "vm_dns_list" {
  description = "Nameserver addresses for the virtual machine"
  type        = list(string)
}

variable "vm_suffix_list" {
  description = "DNS search domains for the virtual machine"
  type        = list(string)
}

variable "vm_folder" {
  description = "Folder where the virtual machine will be placed"
  type        = string
}

variable "os_type" {
  description = "Type of operating system (windows or linux)"
  type        = string
}

variable "vm_list" {
  description = "A multi-line string containing VM configurations separated by new lines"
  type        = string
}
