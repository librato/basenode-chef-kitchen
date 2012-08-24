#
# Enable collectd inputs
#

include_recipe "collectd"

# Define the inputs we are interested in
# TODO: make this configurable
collectd_plugin "inputs" do
  template "collectd_inputs.conf.erb"
  cookbook "misc"
end
