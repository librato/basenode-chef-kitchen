
cookbook_file "/usr/bin/ec2nodename" do
  source "ec2nodename"
  owner "root"
  mode "0755"
end
