#
# This recipe simply runs 'apt-get upgrade'.
#

include_recipe "apt"

bash "run_apt_get_upgrade" do
  code <<EOH
apt-get upgrade --quiet -y --force-yes
EOH
end
