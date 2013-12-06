
require 'yaml'

#Load the user-data YAML
userdata = YAML.load(%x{curl -s http://169.254.169.254/latest/user-data})

Chef::Log.info("userdata == #{userdata.inspect}")

# Move zookeeper data directory to raid0
bash "move_zk_dir" do
  code <<EOH
/sbin/stop zookeeper
mv #{node[:zookeeper][:data_dir]} /raid0/zookeeper && \
ln -sf /raid0/zookeeper #{node[:zookeeper][:data_dir]}
EOH
  not_if {File.exist?("/raid0/zookeeper")}
end

myinst = userdata[:instance] || "0"
nodename = "%s-%s" % [userdata[:node_name], myinst]

# Update the list of zookeeper servers
#

template "/tmp/zoo-servers.cfg" do
  source "zoo-servers.cfg.erb"
  owner "root"
  variables :servers => userdata[:zoo_servers]
end

bash "update_zookeeper_config" do
  code <<EOH
egrep -v ^server #{node[:zookeeper][:conf_dir]}/zoo.cfg > /tmp/zoo.new.cfg && \
cat /tmp/zoo-servers.cfg >> /tmp/zoo.new.cfg && \
cat /tmp/zoo.new.cfg > #{node[:zookeeper][:conf_dir]}/zoo.cfg && \
echo -n "#{myinst}" > #{node[:zookeeper][:data_dir]}/myid
EOH
end

bash "start_zookeeper" do
  code <<EOH
/sbin/start zookeeper
EOH
end

# Create zk_monitor cron script
template "/usr/local/cron_scripts/zk_monitor.sh" do
  source "/usr/local/cron_scripts/zk_monitor.sh.template"
  local true
  owner "root"
  mode "0755"
  variables(:email => userdata[:zkmonitor][:email],
            :api_token => userdata[:zkmonitor][:api_token],
            :api => userdata[:zkmonitor][:api])
end

cron "run_zk_monitor" do
  minute "*/5"

  command "/usr/local/cron_scripts/zk_monitor.sh"
end
