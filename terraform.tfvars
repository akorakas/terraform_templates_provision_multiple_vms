vsphere_user     = "watson@vsphere.local"
vsphere_password = "$E:uu2j9YB@t6h|&4FWH"
vsphere_server   = "vcenter.gcloud.gsis.gr"

datacenter       = "gcloud.gsis.gr"
datastore        = "ADM02-DATA"
resource_pool    = "/gcloud.gsis.gr/host/G-Cloud Next Gen//Resources"
network          = "VLAN 3301 - 10.101.32.0%2f28"
template         = "ng-rh-template"
vm_folder        = "/Efka"
os_type          = "linux"

vm_cpu           = 8
vm_memory        = 64
vm_disk_size     = 50

vm_domain        = "gcloud.gsis.gr"
vm_dns_list      = ["10.9.209.69", "10.9.209.70"]
vm_suffix_list   = ["gcloud.gsis.gr"]

vm_list = <<EOT
PRODWEBINTVM1,10.101.32.34,255.255.255.240,10.101.32.33
PRODWEBINTVM2,10.101.32.35,255.255.255.240,10.101.32.33
PRODWEBINTVM3,10.101.32.36,255.255.255.240,10.101.32.33
EOT
