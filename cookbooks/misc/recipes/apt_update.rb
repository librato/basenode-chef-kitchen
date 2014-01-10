#
# This recipe simply runs 'apt-get update'.
#

include_recipe "apt"

bash "run_apt_get_update" do
  code <<EOH
apt-get update --quiet -y --force-yes
EOH
end
