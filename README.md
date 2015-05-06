These are my notes on developing with Chef.

[Developing With Windows, TestKitchen and Docker](Developing-With-Windows-TestKitchen-and-Docker.md) describes a method of developing a simple Chef cookbook for Centos and Ubuntu using boot2docker on Windows.

The [git-cookbook](git-cookbook) directory was created by working through the [Test Kitchen Getting Started Guide](http://kitchen.ci/docs/getting-started) using the toolset described by [Developing With Windows, TestKitchen and Docker](Developing-With-Windows-TestKitchen-and-Docker.md). I modified the *platforms* section to include the use of my [tragus/chef-omnibus](https://registry.hub.docker.com/u/tragus/chef-omnibus/) image which has the Chef omnibus and a couple of other things baked in to make the test process quicker.
