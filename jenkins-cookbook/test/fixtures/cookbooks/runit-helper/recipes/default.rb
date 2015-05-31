#
# Cookbook Name:: runit_helper
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'runit'

platform = node['platform']
runsvdir = node['runit_helper'][platform]['start']
log("Launching runit with #{runsvdir} ...")

# This is gross (also see .kitchen.yml). I just need runit to be up and running
# for the test / example. You wouldn't want to do this in a real cookbook.
bash 'launch-runit' do
    code <<-EOF
        killall -0 runsvdir || (
            nohup #{node['runit_helper'][platform]['start']} 2>&1 &
            sleep 15
            ps -aef > /tmp/ps-aef
        )
    EOF
end

log("runit should be ready to go")
