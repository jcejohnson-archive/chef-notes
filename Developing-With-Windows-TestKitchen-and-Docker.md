Notes on Chef Development
=========================

My goal is to use my Windows 8.1 laptop as a development environment for Chef cookbooks targeting Linux hosts:

- Use SourceTree, Sublime Text and other nice GUI tools.
- Execute kitchen commands in a cmd, PowerShell or GitBash window.
- Use Docker for the kitchen targets because it is very fast and light-weight.


Disclaimer:
I am a Linux guy, not a Windows fan. I want to use the Windows laptop because that is what I and many of my peers use in our day jobs. It isn't reasonable in that environment to have a Linux workstation, dual-boot or run a full Linux desktop in a VM.


Preparing The Laptop
--------------------

### Install Some Tools

* SourceTree
* git
* gitbash / gitshell
* GitHub
* PuTTY/KiTTY
* Sublime Text 3
* ChefDK (https://downloads.chef.io/chef-dk/)

Substitute favorite replacements as appropriate.

### Install and Test boot2docker

Download the installer from http://docs.docker.com/installation/windows/. Let it install all of the tools it provides.

	> boot2docker.exe version
	Boot2Docker-cli version: v1.6.0
	Git commit: 9894ae9
	> "c:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version
	4.3.26r98988

Launch boot2docker, set the appropriate environment variables and run the hello-world example. You should also be able to do *docker ps*, *docker images* and other docker commands in a cmd, PowerShell or GitBash window.

I initially installed VirtualBox before installing boot2docker and I had issues with the docker command not talking to the docker daemon. I played some tricks with port forwarding in VirtualBox and it worked but my Test Kitchen attempts failed. I removed VirtualBox and boot2docker then reinstall boot2docker and let it install VirtualBox and now things are working. YMMV 


Testing Test Kitchen
--------------------

Before we can dive in and start doing Real Work, we need to make sure that kitchen will cooperate with the environment we've created.

Follow the instructions at http://kitchen.ci/docs/getting-started/creating-cookbook but use the Kitchen::Docker driver instead of Vagrant.

Set the appropriate environment variables before invoking *kitchen init*:

	set PATH=%PATH%;c:\users\james\.chefdk\gem\ruby\2.1.0\bin
	set DOCKER_HOST=tcp://192.168.59.103:2376
	set DOCKER_CERT_PATH=C:\Users\James\.boot2docker\certs\boot2docker-vm
	set DOCKER_TLS_VERIFY=1
	kitchen init --driver=kitchen-docker

Modify .kitchen.yml to configure Kitchen::Docker

	---
	driver:
	  name: docker
	  image: ubuntu:12.04
	  binary: docker
	  socket: tcp://192.168.59.103:2376
	  platform: ubuntu
	  require_chef_omnibus: true

	provisioner:
	  name: chef_zero

	platforms:
	  - name: ubuntu-12.04
	  	driver:
	  		instance_name: chef_ubuntu
	  - name: centos-6.6
	  	driver:
	  		instance_name: chef_centos

	suites:
	  - name: default
	    run_list:
	      - recipe[git::default]
	    attributes:

If everything is setup correctly you can now do:

	> kitchen list
	> kitchen create all

The first image pull will take a moment. After that, things will be blazingly fast.

You can use docker commands to see the images and containers and even launch a shell:

	> docker images
	> docker ps
	> docker exec -i -t <image-name> /bin/bash
		root@...:/# cat /etc/os-release
		NAME="Ubuntu"
		VERSION="12.04.5 LTS, Precise Pangolin"
		ID=ubuntu
		ID_LIKE=debian
		PRETTY_NAME="Ubuntu precise (12.04.5 LTS)"
		VERSION_ID="12.04"


Continue The Tutorial
---------------------

At this point you can continue the [Getting Started Guide](http://kitchen.ci/docs/getting-started).

When you get to [Adding a Dependency](http://kitchen.ci/docs/getting-started/adding-dependency), before you *gem install berkshelf*, you will need to add two directories to your PATH. How you do it depends on whether you're using cmd, PowerShell or GitBash. This is how I did it in a cmd window:

```
PATH=%PATH%;c:\opscode\chefdk\embedded\bin\gem;c:\users\<Username>\.chefdk\gem\ruby\2.1.0\bin
```