#
#
# Github appears to ECONNRESET the first clone from a new IP.
# Perform a bogus clone to whitelist our IP.
#

include_recipe "git"

bash "github_whitelist" do
  code <<EOH
git clone git://github.com/librato/collectd-librato.git /tmp/gh_whitelist
rm -rf /tmp/gh_whitelist
exit 0
EOH
end
