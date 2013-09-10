#
# Cookbook Name:: zookeeper
# Recipe:: default
#
# Copyright 2010, Infochimps, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# XXX: Java 7?
include_recipe "java"

include_recipe "zookeeper::iptables"

group_name = node[:zookeeper][:group]
user_name = node[:zookeeper][:user]

group group_name do
  action [:create]
end

user user_name do
  comment    'Zookeeper Daemon User'
  group      group_name
  home       node[:zookeeper][:data_dir]
  shell      "/bin/false"
  password   nil
  supports   :manage_home => false
  action     [:create]
end

directory "/opt/src"

version = node[:zookeeper][:version]
remote_file "/opt/src/zookeeper-#{version}.tar.gz" do
  source "#{node[:zookeeper][:mirror]}/zookeeper-#{version}/zookeeper-#{version}.tar.gz"
  checksum node[:zookeeper][:checksum]
  mode "0644"
end

destdir = "/opt/zookeeper-#{version}"

[node[:zookeeper][:conf_dir]].each do |dir|
  directory dir do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end
end

[node[:zookeeper][:data_dir], node[:zookeeper][:log_dir]].each do |dir|
  directory dir do
    owner node[:zookeeper][:user]
    group node[:zookeeper][:group]
  end
end

bash "untar_zookeeper" do
  user "root"
  cwd "/opt"
  code %(tar zxf /opt/src/zookeeper-#{version}.tar.gz)
  not_if { File.exists? destdir }
end

link "/opt/zookeeper" do
  to "/opt/zookeeper-#{version}"
end

bash "copy zk conf" do
  user "root"
  cwd destdir
  code %(cp -R ./conf/* #{node[:zookeeper][:conf_dir]})
  not_if { File.exists? "#{node[:zookeeper][:conf_dir]}/zoo_sample.cfg" }
end

template "/etc/init/zookeeper.conf" do
  source "upstart.conf.erb"

  owner "root"
  mode "0644"

  variables({ :service => "zookeeper",
              :java_home => node[:java][:java_home] })
end

service "zookeeper" do
  provider Chef::Provider::Service::Upstart
end

# service "zookeeper" do
#   subscribes :restart, resources(:bash => "untar_zookeeper")
# end

template_variables = {
  :servers           => node[:zookeeper][:servers],
  :myid              => node[:zookeeper][:myid],
  :data_dir          => node[:zookeeper][:data_dir],
  :log_dir           => node[:zookeeper][:log_dir],
  :tick_time         => node[:zookeeper][:tick_time],
  :init_limit        => node[:zookeeper][:init_limit],
  :sync_limit        => node[:zookeeper][:sync_limit],
  :client_port       => node[:zookeeper][:client_port],
  :quorum_port       => node[:zookeeper][:quorum_port],
  :leader_elect_port => node[:zookeeper][:leader_elect_port],
  :max_client_conns  => node[:zookeeper][:max_client_connections],
  :snap_retain_count => node[:zookeeper][:snap_retain_count],
  :purge_interval    => node[:zookeeper][:purge_interval]
}

%w[ zoo.cfg log4j.properties].each do |conf_file|
  template "#{node[:zookeeper][:conf_dir]}/#{conf_file}" do
    owner "root"
    mode "0644"
    variables(template_variables)
    source "#{conf_file}.erb"
    notifies :restart, resources(:service => "zookeeper")
  end
end

template "#{template_variables[:data_dir]}/myid" do
  owner user_name
  mode "0644"
  variables(template_variables)
  source "myid.erb"
  notifies :restart, resources(:service => "zookeeper")
end
