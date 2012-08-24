
package "gawk"

# Install the run_with_env.sh wrapper
#
cookbook_file "/usr/local/bin/run_with_env" do
  source "run_with_env.sh"
  owner "root"
  mode "0755"
end
