Chef Notes
==========
These are my notes on developing with Chef.

## Developing With Windows, TestKitchen and Docker

[Developing With Windows, TestKitchen and Docker](Developing-With-Windows-TestKitchen-and-Docker.md) describes a method of developing a simple Chef cookbook for Centos and Ubuntu using boot2docker on Windows.

### Setting knife editor

This was really painful to figure out.
```
knife[:editor] = '"C:\\Program Files\\Sublime Text 3\\sublime_text.exe"'
```
Note the single quotes around the double-quoted string. See [CHEF-4503](https://tickets.opscode.com/browse/CHEF-4503).

## git-cookbook

The [git-cookbook](git-cookbook) directory was created by working through the [Test Kitchen Getting Started Guide](http://kitchen.ci/docs/getting-started) using the toolset described by [Developing With Windows, TestKitchen and Docker](Developing-With-Windows-TestKitchen-and-Docker.md). I modified the *platforms* section to include the use of my [tragus/chef-omnibus](https://registry.hub.docker.com/u/tragus/chef-omnibus/) image which has the Chef omnibus and a couple of other things baked in to make the test process quicker.

## jenkins-cookbook

The [jenkins-cookbook](jenkins-cookbook) directory is a simple example of a master/slave node pair using the kitchen-docker driver. It illustrates an approach for testing multi-node integration with Test Kitchen.

## Vagrant

### ssh into the test node

In most cases you can use _kitchen login_ to login to the test node. If you want to ssh directly for some reason, you will need to find and use the private key that has been created for you:

```
ssh -i .kitchen/kitchen-vagrant/kitchen-${cookbook_name}-${instance}/.vagrant/machines/default/virtualbox/private_key
```

where _instance_ is taken from the _Instance_ column of _kitchen list_.

You can also get this path from the _kitchen diagnose ${suite}_ output at the path _instances.instance.state_file.ssh\_key_
