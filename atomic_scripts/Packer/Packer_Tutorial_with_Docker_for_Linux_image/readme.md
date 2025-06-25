# Readme
- Reference https://developer.hashicorp.com/packer/tutorials/docker-get-started
- Steps to run:
    1. open a shell to the directory this file is located at
    2. run these commands:
        packer init .
        packer fmt .
        packer validate .
        packer build docker-ubuntu.pkr.hcl
        docker images 
    3. The new image should be listed by the last command.  The image can be removed later using the "docker rmi <IMAGE_ID>" command.