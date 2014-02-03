# scape-demo-sites

Web based demonstrators for SCAPE tools.

### What does scape-demo-sites do?

This project is used to set up the scape web demonstrators on a web server running PHP.  The official demonstrator can be found at http://scape.opf-labs.org.

The project can also be used to easily set up a local VM instance of the demonstrator, for developers or curious users.

### Intended Audience

The project is for:
 * Users looking to try the SCAPE demonstrator on a local VM, see .
 * Developers looking to create their own SCAPE demonstrator, see [Developing SCAPE Demonstrators](#creating).
 * Web admins wanting to deploy the SCAPE demonstrators to a local web server, see [Deploying the Demonstrator](#deploying).

## <a name="starting"></a>Getting Started

This section describes how to use [VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) to quickly set up a local VM that runs the SCAPE demonstrators.  This is particluarly useful for developers looking to enhance existing demonstrators, or create new ones.  It can also be used by people wanting a local demonstrator VM, for whatever reason.

### Requirements

You'll need to have [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://www.vagrantup.com/downloads.html) installed, these are available for Windows, OS X, and most common Linux distros.

You'll also need TCP/IP port 2020 free on your local machine.

### Installation

First clone this repository, if you've not already done so, and move into your local directory copy:
```
git clone git@github.com:openplanets/scape-demo-sites.git
cd scape-demo-sites
```

If this is the first time you're running the local demonstrator VM you'll need to install a [Vagrant box](http://docs.vagrantup.com/v2/boxes.html), in this case an Ubuntu 12.04 LTS box.  A box is a template image from which VMs are created by Vagrant. Issue the following command:
```
vagrant box add precise64 http://files.vagrantup.com/precise64.box
```
It may take a few minutes for the box to download. If you're unsure about whether you have the appropriate Vagrant box downloaded, issue the command:
```
vagrant box list
```
and look for the line:
```
precise64 (virtualbox)
```
amongst the listed boxes, on a linux box ```vagrant box list | grep precise64``` can be used to thin the output if necessary.

### Usage

After installing the box, from your local project directory issue the command ```vagrant up```. This will start the headless VM.  If this is the first time you've run the command the it will provision the VM, that is install the appropriate software for the demonstrator. This is achieved by running the [bootstrap.sh](./bootstrap.sh) shell script.  Open a browser and visit http://localhost:2020 which should show the demonstrator home page.

To stop the demonstrator, from your local project directory issue the command ```vagrant halt```.  This will shut down the VM however the Vagrant box will continue to take up local resources, i.e. disk space, in the ```.vagrant``` sub-directory of the project.  See [Uninstall](#destroying) to see how to free up resources.

To restart the VM at any time issue the ```vagrant up``` command from the project directory.

### <a name="destroying"></a>Uninstall

To completely remove all trace of your demonstrator VM issue the command ```vagrant destroy``` from the local project directory.  Issuing ```vagrant up``` will still re-create the machine, and will re-run [bootstrap.sh](./bootstrap.sh).  Issuing these commands effectively resets the machine to a pristine state.

## <a name="creating"></a>Developing SCAPE Demonstrators

The best way of developing and testing a new demonstrator is to use the Vagrant development VM that accompanies the project.  To get this up an running follow the [Getting Started](#starting) instructions.  Once you can see the demo site on http://localhost:2020 then you're ready to start.

### Your Development VM

The Vagrant VM is configured to use a shared folder pointing to the project root directory, this is mounted on the VM as ```/vagrant```.  Additionally the Apache server ```/var/www``` directory is replaced by a symbolic link to ```/vagrant``` so that the VM's server picks up live changes in the project directory.

#### SSH access to the VM

If required you can get command line access to the VM by issuing the command ```vagrant ssh``` from your local project directory.  This allows you to install software via ```sudo apt-get install```, but any changes you make will survive the [Uninstall](#destroying) process. If you want installed software to be part of the demo VM set up you should add your changes to the [bootstrap.sh](./bootstrap.sh) file, then test by issuing ```vagrant destroy``` followed by ```vagrant up``` to create a new machine instance from the template box.

#### Development

Simply work on your local machine in the project directory then refresh http://localhost:2020 to see changes.  If you want to restart the web server on the VM you can:
```
vagrant ssh
sudo service apache2 restart
exit
```
from the command line in the project dir.  To reboot the VM issue:
```
vagrant halt
vagrant up
```
again from the command line in the project dir.

Any changes made to [bootstrap.sh](./bootstrap.sh) provisioning script, or the web project files should be committed to your local git repo.

#### Sharing Your Changes

If you have push access to the GitHub repo you can share your changes directly, if not you'll need to create a pull requrest from your copy. *PLEASE DON'T* consider doing this until you've tried:
```
vagrant destroy
vagrant up
```
to ensure that everything works from a clean install.  If this is OK then go ahead and push to GitHub or issue the pull request.

#### Creating a New Demonstrator

1. Create a folder with the name of your tool: ex: pagelyzer, xcorrsound etc. 
2. Copy the files index.html and check.php in Templates folder to your new folder 
3. Update these two files according to your needs 

If you would like to change the interface, please create a new StyleJS folder and add your css and js files into it. 
Once we have different propositions, we can choose one to apply to all tools demo.

## <a name="deploying"></a>Deploying the Demonstrator

*TODO* Deployment script and instructions.

## More Information

The [Vagrant Getting Started Guide](http://docs.vagrantup.com/v2/getting-started/index.html) is unsurprisingly a good introduction to using Vagrant.

