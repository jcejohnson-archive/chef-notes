tragus_jenkins Cookbook
=========================

This is *not* meant to be a general purpose Jenkins cookbook. Its only purpose is to illustrate using Docker and Test Kitchen with multiple nodes in a master/slave relationship.

Requirements
------------
- Docker
- Test Kitchen
- kitchen-docker
- kitchen-nodes

Use Case
--------

Jenkins, like many other tools, is composed of two parts: master & slave. The master drives the action and directs zero or more slaves to execute jobs. In my day job I work for an company with many internal organizations (a.k.a. - business units). Each of those organizations has one or more development teams and a dedicated Jenkins master with multiple slaves. I need to create Chef recipes that allow us to deploy and manage these multiple masters and their many slaves. In order to do that, I need a mechanism for testing the process -- specifically, the ability for the slaves to find and attach to (via jnlp) the correct master out of the dozens that are known to the Chef server.

Test Kitchen isn't necessarily designed for multi-node testing but with the kitchen-nodes provisioner and explicit use of the kitchen lifecycle components we can do a very good job of testing this kind of scenario.

Kitchen::Nodes
--------------

TODO -- Document how this is useful.

Testing
-------

```
kitchen destroy
kitchen verify centos
kitchen destroy
kitchen verify ubuntu
kitchen destroy
```

runit
-----

I am having issues with runit when executing my slave-node test case with the Kitchen::Docker driver. On every first convergence of the slave node I get the error:
```
warning: /etc/service/jenkins-slave: unable to open supervise/ok: file does not exist
```
When I run _kitchen converge_ a second time, there is no error but the Jenkins slave is not running. If I attach to the container and manually start runsvdir the slave is launched successfully.

### phusion/dockerimage

I eventually settled on using phusion/dockerimage and a custom [Dockerfile](test/docker/Dockerfile-phusion). This locks me into Ubuntu 14.04 for the slave or requires me to create a phusion-like base image for each platform I want to test.

### [run-docker.sh](run-docker.sh)

The custom Dockerfile uses COPY to inject an [runit entry script to launch sshd](test/docker/tk-sshd.sh) in the way that kitchen-docker wants it to execute. kitchen-docker builds its image using 'docker build -'. Unfortunately, feeding the Dockerfile to 'docker build' on stdin breaks COPY because the working directory is not where you think it is. To handle this, [.kitchen.yml](.kitchen.yml) specifies run-docker.sh as the docker binary. run-docker.sh saves the stdin-provided Dockerfile content into a file and invokes 'docker build -f <filename> .'

### //sbin/my_init

When [testing on Windows](Developing-With-Windows-TestKitchen-and-Docker.md) I ran into one final issue. I need to replace the command kitchen-docker gives to 'docker run' with /sbin/my_init from phusion/dockerimage (this is the bit that makes runit work with Docker). If I specify /sbin/my_init for the run_command in .kitchen.yml, it will be mangled into C:/Program Files (x86)/Git/sbin/my_init when run-docker.sh is invoked by gitbash. The workaround is to add an extra leading slash so that gitbash will leave it alone: 'run_command: //sbin/my_init'

Beyond Jenkins
--------------

Of course, you could apply this same technique to other master/slave or server/client setups. Though I have used Jenkins as my example, the approach will work equally well for any similar application. On the other hand, not all master/slave or server/client application architectures will lend themselves to this. In particular, situations where the slave/client component discovers its master/server rather than being told where to attach (in this case, by Chef), is probably inappropriate.
