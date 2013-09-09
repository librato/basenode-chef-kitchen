
#runit_service "zookeeper"

template "/usr/local/cron_scripts/zk_purge_txnlogs.sh" do
  source "zk_purge_txnlogs.sh.erb"
  mode "0755"
end
