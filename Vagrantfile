# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # Use the precised64 box, change this for 32 bit, or other distro
    config.vm.box = "hashicorp/precise64"

    # Run the provisioning script	
    config.vm.provision :shell, :path => "./provision/bootstrap.sh"

    # Port forward HTTP (80) to host 2020
    config.vm.network :forwarded_port, host: 2020, guest: 80

    # Set the box host-name
    config.vm.hostname = "scape-demos"

    # VirtualBox specific, set the virtual box name
    config.vm.provider "virtualbox" do |v|
        v.name = "scape-demos-dev"
    end
end
