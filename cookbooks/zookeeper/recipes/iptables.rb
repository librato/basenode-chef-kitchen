include_recipe "iptables"

iptables_rule "10zookeeper" do
  source "iptables.erb"
  variables(:client_port => node[:zookeeper][:client_port],
            :quorum_port => node[:zookeeper][:quorum_port],
            :leader_elect_port => node[:zookeeper][:leader_elect_port])
end
