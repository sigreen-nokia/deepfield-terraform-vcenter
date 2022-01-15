terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.0.2"
    }
  }
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc_1" {
  name = "Deepfield"
}

data "vsphere_datastore" "datastore_1" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.dc_1.id
}

data "vsphere_datastore" "datastore_2" {
  name          = "datastore1 (1)"
  datacenter_id = data.vsphere_datacenter.dc_1.id
}

data "vsphere_datastore" "datastore_synology" {
  name          = "synology"
  datacenter_id = data.vsphere_datacenter.dc_1.id
}

data "vsphere_resource_pool" "pool_1" {
  name          = "Deepfield1"
  datacenter_id = data.vsphere_datacenter.dc_1.id
}

data "vsphere_network" "network_1" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc_1.id
}

data "vsphere_network" "network_2" {
  name          = "deepfield_private"
  datacenter_id = data.vsphere_datacenter.dc_1.id
}

data "vsphere_network" "network_3" {
  name          = "deepfield_data_collection"
  datacenter_id = data.vsphere_datacenter.dc_1.id
}


