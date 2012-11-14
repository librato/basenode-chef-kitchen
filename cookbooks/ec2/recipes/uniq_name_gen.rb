
#
# This file can create a unique ID in a namespace. Useful for
# naming of nodes.
#
package "python-pip"

bash "upgrade boto" do
  code <<EOH
pip install --upgrade boto
EOH
end

cookbook_file "/usr/local/bin/uniq_name_gen.py" do
  owner "root"
  mode "0755"
end
