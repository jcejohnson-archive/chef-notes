#
# Cookbook Name:: tragus_jenkins
# Recipe:: master
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node.set['jenkins']['master']['install_method'] = 'package'

include_recipe 'tragus_jenkins::default'
include_recipe 'jenkins::master'
