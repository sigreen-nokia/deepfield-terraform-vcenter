
data "vsphere_datacenter" "dc_basic" {
  name = "Deepfield"
}

data "vsphere_datastore" "datastore_basic" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.dc_basic.id
}

data "vsphere_resource_pool" "pool_basic" {
  name          = "Deepfield1"
  datacenter_id = data.vsphere_datacenter.dc_basic.id
}

data "vsphere_network" "network_basic" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc_basic.id
}

resource "vsphere_virtual_machine" "vm_basic" {
  name             = "terraform-test"
  resource_pool_id = data.vsphere_resource_pool.pool_basic.id
  datastore_id     = data.vsphere_datastore.datastore_basic.id

  wait_for_guest_net_timeout = -1 
  wait_for_guest_ip_timeout  = 0

  num_cpus = 2
  memory   = 1024
  guest_id = "other3xLinux64Guest"

  network_interface {
    network_id = data.vsphere_network.network_basic.id
  }

  disk {
    label = "disk0"
    size  = 20
  }
}

