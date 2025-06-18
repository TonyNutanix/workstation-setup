# This is from here: https://github.com/nutanix-cloud-native/packer-plugin-nutanix/tree/main/test/e2e/centos-iso/scripts

build {
  source "nutanix.centos" {
    name = "centos"
  }

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }
}