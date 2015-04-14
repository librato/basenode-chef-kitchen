#
# Run the first time a node is booted.
#

require 'yaml'

#Load the user-data YAML
userdata = YAML.load(%x{curl -s http://169.254.169.254/latest/user-data})
myip = node['ipaddress']
myaz = node['ec2']['placement_availability_zone']

Chef::Log.info("userdata == #{userdata.inspect}")

nodename = ""
broker_id = userdata[:instance]

if broker_id.nil? && userdata[:uniq_name_gen]
  # Try to acquire a new unique instance ID
  1.upto(3) do
    cmd = "/usr/local/bin/uniq_name_gen.py"
    nspace = userdata[:uniq_name_gen][:namespace]
    key = userdata[:uniq_name_gen][:access_key]
    skey = userdata[:uniq_name_gen][:secret_key]
    broker_id = %x{#{cmd} #{nspace} #{key} #{skey}}.chomp
    unless $?.success?
      broker_id = nil
      Chef::Log.warn("Failed to acquire a unique instance ID...sleeping for 30 secs")
      # Randomize sleep time in case of racing
      sleep 20 + rand(10)
    end
  end
end

if broker_id
  Chef::Log.info "Got an instance ID of #{broker_id}"
  node.set[:uniq_instance_id] = broker_id
  nodename = "#{userdata[:node_name]}_#{broker_id}"
end

# Update rsyslog name (papertrail)
bash "update_rsyslog_name" do
  code <<EOH
sed -i -e 's/%timegenerated% .* %syslogtag%/%timegenerated% #{nodename} %syslogtag%/g' \
    /etc/rsyslog.d/61-fixhostnames.conf && \
restart rsyslog
EOH
end

# Update the collectd hostname
node.set[:collectd][:hostname] = nodename

# Merge collectd librato configuration from userdata
node.set[:collectd_librato] = userdata[:collectd_librato]

# Merge collectd librato configuration from userdata
node.set[:papertrail] = userdata[:papertrail]

# Merge any user data into basenode settings
node.set[:basenode][:add_users] = userdata[:users] || {}

# Merge any iptables settings
node.set[:basenode][:tcp_ports] = userdata[:tcp_ports]
node.set[:basenode][:udp_ports] = userdata[:udp_ports]

if userdata[:statsite]
  # Update the statsite configuration
  bash 'update_statsite_config' do
    code <<EOH
sed -i \
    -e 's/%%EMAIL%%/#{userdata[:statsite][:email]}/g' \
    -e 's/%%TOKEN%%/#{userdata[:statsite][:api_token]}/g' \
    -e 's@%%API%%@#{userdata[:statsite][:api]}@g' \
    -e 's/%%HOSTNAME%%/#{nodename}/g' \
    -e 's/%%INTERVAL%%/#{userdata[:statsite][:interval]}/g' \
    -e 's@%%SOURCE_REGEX%%@#{userdata[:statsite][:source_regex] || node[:default_source_regex]}@g' \
    /etc/statsite/librato.conf && \
sed -i \
    -e 's/%%INTERVAL%%/#{userdata[:statsite][:interval]}/g' \
    /etc/statsite.conf
EOH
  end

  bash "start_statsite" do
    code <<EOH
/sbin/stop statsite || true
/sbin/start statsite
EOH
  end

end

# Set PS1 - should really do this as a PS1.conf file in /etc/profile.d
bash 'set_ps1' do
  code <<EOH
echo 'export PS1="\\u@#{nodename}:\\w# "' >> /root/.bashrc
echo 'export PS1="\\u@#{nodename}:\\w$ "' >> ~ubuntu/.bashrc
EOH
end

# Add the history format hack so that it shows dates on each command
bash 'add_timestamp_to_history' do
  code <<EOH
echo "export HISTTIMEFORMAT='%F %T '" >> /etc/bash.bashrc
echo "export HISTTIMEFORMAT='%F %T '" >> /etc/profile
EOH
end

if userdata[:jstatd]
  node.set[:jstatd] = userdata[:jstatd]
  node.set[:basenode][:tcp_ports].push(node[:jstatd][:port])
  include_recipe 'basenode::jstatd'
end


ruby_block 'ensure node can resolve its own name' do
  block do
    fe = Chef::Util::FileEdit.new("/etc/hosts")
    fe.insert_line_if_no_match(/#{node['ipaddress']}/,
                               "#{node['ipaddress']} #{node['fqdn']} #{node['hostname']}")
    fe.write_file
  end
end
