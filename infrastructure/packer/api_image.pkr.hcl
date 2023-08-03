packer {
  required_plugins {
    docker = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ssa-api"
  instance_type = "t2.micro"
  region        = "us-west-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

}

provisioner "file" {
  source = "../../api/main.py"
  destination = "/tmp/main.py"
}

provisioner "shell"{
  inline = [
    "sudo apt-get update",
    "sudo apt-get upgrade -y",
    "sudo apt-get install python3-pip -y",
    "sudo pip install flask"
    ]

}


build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}