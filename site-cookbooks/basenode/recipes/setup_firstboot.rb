include_recipe "basenode"

directory node[:basenode][:base_dir] do
  action :create
  mode "0755"
end

autostartdir = File.join(node[:basenode][:base_dir],
                         node[:basenode][:autostart_dir])

directory autostartdir do
  action :create
  mode "0755"
end

autostartsh = File.join(node[:basenode][:base_dir],
                        node[:basenode][:autostart_script])

template autostartsh do
  source "autostart.sh.erb"
  mode "0755"
  variables({ :autostart_dir => autostartdir,
              :log_file => "/tmp/autostart.log",
              :max_script_time_secs => 420 })
end

bash "add_to_rclocal" do
  code <<EOH
echo '#{autostartsh}' > /etc/rc.local
echo 'exit 0' >> /etc/rc.local
EOH
  not_if {File.read("/etc/rc.local").include?(autostartsh)}
end

chefbootsh = File.join(autostartdir, "01_chef_firstboot.sh")

template chefbootsh do
  source "chef_firstboot.sh.erb"
  owner "root"
  mode "0755"
  variables ({ :role => "firstboot",
               :chef_solo_dir => "/var/chef/basenode-kitchen"})
end

# Copy chef kitchen to backup location
bash "backup_chef_kitchen" do
  currloc = %x{cat /etc/chef/solo.rb | egrep ^role_path | cut -d ' ' -f 2}.chomp.
    gsub('"', '').gsub("/roles", "")
  code <<EOH
mkdir -p /var/chef && \
cp -r #{currloc} /var/chef/basenode-kitchen
EOH
end
