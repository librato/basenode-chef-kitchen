#
# Cookbook Name:: zknode
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "/usr/local/cron_scripts"
directory "/usr/local/scripts"

# Setup ZK monitoring template
cookbook_file "/usr/local/cron_scripts/zk_monitor.sh.template" do
  source "zk_monitor.sh.template"
  owner "root"
  mode "0755"
end

chefbootsh = File.join("/etc/basenode/autostart.d",
                       "10_setup_zknode.sh")

template chefbootsh do
  source "chef_firstboot.sh.erb"
  owner "root"
  mode "0755"
  variables ({ :role => "zknode_firstboot",
               :chef_solo_dir => "/var/chef/zknode-kitchen"})
end

# Copy chef kitchen to backup location
bash "backup_chef_kitchen" do
  currloc = %x{cat /etc/chef/solo.rb | egrep ^role_path | cut -d ' ' -f 2}.chomp.
    gsub('"', '').gsub("/roles", "")
  code <<EOH
mkdir -p /var/chef && \
cp -r #{currloc} /var/chef/zknode-kitchen
EOH
end
