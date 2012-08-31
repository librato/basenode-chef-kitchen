#
# Run the first time a node is booted.
#

require 'yaml'

#Load the user-data YAML
userdata = YAML.load(%x{curl -s http://169.254.169.254/latest/user-data})
myip = %x{curl -s http://169.254.169.254/latest/meta-data/local-ipv4}.chomp
myaz = %x{curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone}.chomp

Chef::Log.info("userdata == #{userdata.inspect}")

inst = userdata[:instance] || 0
nodename = "#{userdata[:node_name]}-#{inst}"

# Update rsyslog name (papertrail)
bash "update_rsyslog_name" do
  code <<EOH
sed -i -e 's/%timegenerated% .* %syslogtag%/%timegenerated% #{nodename} %syslogtag%/g' \
    /etc/rsyslog.d/61-fixhostnames.conf && \
restart rsyslog
EOH
end

# Update the collectd hostname
bash "update_collectd_hostname" do
  code <<EOH
sed -i -e 's/%%HOSTNAME%%/#{nodename}/g' /etc/collectd/collectd.conf && \
/etc/init.d/collectd restart
EOH
end

# Set PS1
bash "set_ps1" do
  code <<EOH
echo 'export PS1="\\u@#{nodename}:\\w# "' >> /root/.bashrc
echo 'export PS1="\\u@#{nodename}:\\w$ "' >> ~ubuntu/.bashrc
echo 'export PS1="\\u@#{nodename}:\\w$ "' >> ~metrics/.bashrc
EOH
end

# Add the history format hack so that it shows dates on each command
bash "add_timestamp_to_history" do
  code <<EOH
echo "export HISTTIMEFORMAT='%F %T '" >> /etc/bash.bashrc
echo "export HISTTIMEFORMAT='%F %T '" >> /etc/profile
EOH
end

