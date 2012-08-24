
define :firewall_port_scan, :variables => {} do
  include_recipe "iptables"

  vars = params[:variables]
  iptables_rule "no_port_scan_#{params[:name]}" do
    source "no_port_scan.erb"

    variables(vars)
  end
end
