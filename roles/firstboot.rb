name "firstboot"
description "Run at first boot to configure node"

attrs = {
}

default_attributes(attrs)

run_list(["recipe[basenode::firstboot]",
          "recipe[collectd-librato::install]",
          "recipe[ec2::raid_ephemeral]",
          ])
