# Setup and install statsite
#
directory "/etc/statsite" do
  owner "root"
  mode "0755"
end

template "/etc/statsite/librato.conf" do
  source "statsite_librato.conf.erb"
  owner "root"
  mode "0744"
  variables :conf => node[:statsite_librato]
end
