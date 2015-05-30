#
# Cookbook Name:: tragus_jenkins
# Recipe:: slave
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'tragus_jenkins::default'

nodes = search(:node, "#{node['jenkins']['slave']['search_for_master']}")
master = nodes.first

node.set['jenkins']['master']['endpoint'] = master['jenkins']['master']['public_endpoint']

log("Located master public endpoint - #{node['jenkins']['master']['endpoint']}")

jenkins_jnlp_slave 'builder'
