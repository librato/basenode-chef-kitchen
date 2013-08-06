include_recipe "iptables"

iptables_rule "basenode_boot_ports" do
  source "iptables.erb"

  variables(:tcp_ports => (node[:basenode][:tcp_ports] || []),
            :udp_ports => (node[:basenode][:udp_ports] || []))

end
