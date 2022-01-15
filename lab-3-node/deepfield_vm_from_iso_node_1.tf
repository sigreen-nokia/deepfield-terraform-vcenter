
data "vsphere_virtual_machine" "deepfield_node1" {
  name          = "Ubuntu20-template-base"
  datacenter_id = "${data.vsphere_datacenter.dc_1.id}"
}

variable "disk_size_node1" {}

resource "vsphere_virtual_machine" "vm_deepfield_node1" {
  name             = "deepfield_node1"
  resource_pool_id = data.vsphere_resource_pool.pool_1.id
  datastore_id     = data.vsphere_datastore.datastore_2.id
  wait_for_guest_net_timeout = -1 
  wait_for_guest_ip_timeout  = 0
  num_cpus = 6
  memory   = 20480 
  guest_id = "${data.vsphere_virtual_machine.deepfield_node1.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.deepfield_node1.scsi_type}"


  network_interface {
    network_id = data.vsphere_network.network_1.id
  }

  network_interface {
    network_id = data.vsphere_network.network_2.id
  }

  network_interface {
    network_id = data.vsphere_network.network_3.id
  }

  disk {
    label            = "disk0"
    size             = var.disk_size_node1
    eagerly_scrub    = "${data.vsphere_virtual_machine.deepfield_node1.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.deepfield_node1.disks.0.thin_provisioned}"
  }

  cdrom {
     datastore_id = "${data.vsphere_datastore.datastore_synology.id}"
     path         = "ISOs/deepfield/deepfield-p5.1.28-s5.1.22-bionic.iso"
  }

}

