include_recipe "collectd"

collectd_plugin "librato" do
  template "collectd_librato.conf.erb"
  cookbook "basenode"

  options({ :api => node[:collectd_librato][:api],
            :email => node[:collectd_librato][:email],
            :token => node[:collectd_librato][:api_token]
          })
end
