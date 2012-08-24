#
# Cookbook Name:: postfix
# Recipe:: default
#
# Copyright 2010, Librato, Inc.
#
# All rights reserved - Do Not Redistribute
#

if File.exists?("/etc/init.d/sendmail")
  service "sendmail" do
    supports :status => true
    action [ :stop, :disable ]
  end
end

package "postfix"
