#
# Setup postfix to forward mail to an external SMTP
#

include_recipe 'postfix'

service "postfix" do
  supports :status => true
  action [ :enable, :start ]
end

# Postfix configuration file
template "/etc/postfix/main.cf" do
  source "postfix_main.cf.erb"
  owner "postfix"
  group "postfix"
  mode "0644"
  variables({
              :hostname => node[:postfix][:smtp_host],
            })
  notifies :restart, resources(:service => "postfix")
end

# Postfix user info file
template "/etc/postfix/sasl_passwd" do
  source "postfix_sasl_passwd.erb"
  owner "postfix"
  group "postfix"
  mode "0600"
  variables({
              :hostname => node[:postfix][:smtp_host],
              :user => node[:postfix][:sasl_user],
              :password => node[:postfix][:sasl_password]
            })
  notifies :restart, resources(:service => "postfix")
end

# Compile user info file
script "compile_sasl_passwd" do
  interpreter "bash"
  user "root"
  cwd "/etc/postfix"
  code <<-EOH
      chown postfix: /etc/postfix && \
      postmap hash:/etc/postfix/sasl_passwd && \
      chown postfix: /etc/postfix/sasl_passwd.db
    EOH
  notifies :restart, resources(:service => "postfix")
end
