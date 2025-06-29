packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}

build {
  name    = "AMH-packer-ubuntu"
  sources = [
    "source.docker.ubuntu"
  ]
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ] 
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
   ]
  }
  provisioner "shell" {
    inline = ["echo Running ${var.docker_image} Docker image."]
  }
}
variable "docker_image" {
  type    = string
  default = "ubuntu:jammy"
}

