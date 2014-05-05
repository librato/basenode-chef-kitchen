cookbook_file "/etc/jstatd.all.policy" do
  owner "root"
  mode "0755"
end

template "/etc/init/jstatd.conf" do
  source "jstatd.conf.erb"
  owner "root"
  mode "0744"
  variables({ :port => node[:jstatd][:port],
              :user => "root",
              :java_home => node[:jstatd][:java_home],
              :policy => "/etc/jstatd.all.policy"
            })
end

service "jstatd" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true
  action [:start]
end
