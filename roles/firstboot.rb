name "firstboot"
description "Run at first boot to configure node"

attrs = {
  :collectd => {
    :use_fqdn => false,
    :hostname => '%%HOSTNAME%%',
    :interval => 60
  },
}

default_attributes(attrs)

run_list(["recipe[basenode::firstboot]",
          "recipe[basenode::add_users]",
          "recipe[basenode::iptables]",
          "recipe[collectd-librato::install]",
          "recipe[papertrail]",
          "recipe[ec2::raid_ephemeral]",
          ])
