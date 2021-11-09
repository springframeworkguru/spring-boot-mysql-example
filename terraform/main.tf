// Configure the Google Cloud provider
provider "google" {
 credentials = file("CRED.json")
 project     = "even-sun-331510"
 region      = "us-west1"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}


// A single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "capiter-${random_id.instance_id.hex}"
 machine_type = "f1-micro"  //As the server is intended to run calculate cimplex equations
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
     size  = "20"
   }
 }
 metadata = {
   ssh-keys = "osamamagdy174@gmail.com:${file("~/.ssh/id_ed25519.pub")}"
 }
 
 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }

  lifecycle {
    ignore_changes = [attached_disk]
 }
}

resource "google_compute_disk" "default" {
  name  = "capiter-disk"
  type  = "pd-ssd" //better for intensive applications with low latency
  zone  = "us-west1-a"
  size  = "100"
  labels = {
    environment = "dev"
  }
  physical_block_size_bytes = 4096
}

//Attach the resource disk to be attached to the compute instance
resource "google_compute_attached_disk" "default" {
  disk     = google_compute_disk.default.id
  instance = google_compute_instance.default.id
}

// A variable for extracting the external IP address of the instance
output "ip" {
 value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}