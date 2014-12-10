#
# Cookbook Name:: basenode
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "libcurl4-openssl-dev"
package "gawk"
package "libsasl2-dev"
package "mailutils"
package "sysstat"
package "iftop"

package "mdadm"
package "xfsprogs"
package "libzookeeper-mt-dev"

cookbook_file "/usr/local/bin/run_with_env.sh" do
  owner "root"
  mode "0755"
end
