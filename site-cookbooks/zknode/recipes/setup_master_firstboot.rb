include_recipe "services"

# Setup ZK monitoring template
cookbook_file "/usr/local/cron_scripts/zk_monitor.sh.template" do
  source "zk_monitor.sh.template"
  owner "root"
  mode "0755"
end

include_recipe "services::setup_firstboot"
