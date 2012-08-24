#
# Adds ssh to iptables and sets up anti-port scanning rules.
#
firewall_port_scan "sshd" do
  variables(node[:misc][:ssh_firewall])
end
