
#
# This file can create a unique ID in a namespace. Useful for
# naming of nodes.
#
package "python-boto"

cookbook_file "/usr/local/bin/uniq_name_gen.py" do
  owner "root"
  mode "0755"
end
