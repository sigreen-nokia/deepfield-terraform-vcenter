
data "vsphere_datacenter" "dc_ubuntu2004" {
  name = "Deepfield"
}

data "vsphere_datastore" "datastore_ubuntu2004" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.dc_ubuntu2004.id
}

data "vsphere_resource_pool" "pool_ubuntu2004" {
  name          = "Deepfield1"
  datacenter_id = data.vsphere_datacenter.dc_ubuntu2004.id
}

data "vsphere_network" "network_ubuntu2004" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc_ubuntu2004.id
}

data "vsphere_virtual_machine" "template_ubuntu2004" {
  name          = "Ubuntu20-template-base"
  datacenter_id = "${data.vsphere_datacenter.dc_ubuntu2004.id}"
}


resource "vsphere_virtual_machine" "vm_ubuntu2004" {
  name             = "ubuntu20"
  resource_pool_id = data.vsphere_resource_pool.pool_ubuntu2004.id
  datastore_id     = data.vsphere_datastore.datastore_ubuntu2004.id

  wait_for_guest_net_timeout = -1 
  wait_for_guest_ip_timeout  = 0

  num_cpus = 2
  memory   = 1024
  guest_id = "${data.vsphere_virtual_machine.template_ubuntu2004.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template_ubuntu2004.scsi_type}"


  network_interface {
    network_id = data.vsphere_network.network_ubuntu2004.id
    adapter_type = "${data.vsphere_virtual_machine.template_ubuntu2004.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template_ubuntu2004.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template_ubuntu2004.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template_ubuntu2004.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template_ubuntu2004.id}"

    customize {
      linux_options {
        host_name = "ubuntu2004"
        domain    = "contrailcloud.com"
      }

      network_interface {}

    }
  }

}

