name "base"
description "Base Chef node role"

attrs = {
  :collectd => {
    :use_fqdn => false,
    :hostname => '%%HOSTNAME%%',
    :interval => 60
  },
  :collectd_librato => {
    :api_token => "",
    :email => ""
  },
  :sysctl => {
    :attributes => {
      "net.core.somaxconn" => 2048,
      "net.core.netdev_max_backlog" => 2048
    }
  }
}

default_attributes(attrs)

run_list(["recipe[apt]",
          "recipe[misc::github_whitelist]",
          "recipe[misc::apt_upgrade]",
          "role[ssh]",
          "recipe[ec2::nodename]",
          "recipe[ec2::tools]",
          "recipe[ec2::uniq_name_gen]",
          "recipe[ntp]",
          "recipe[sysctl]",
          "role[postfix]",
          "recipe[mysql::client]",
          "recipe[collectd]",
          "recipe[collectd-librato::build]",
          "recipe[misc::collectd]",
          "role[papertrail]",
          "role[java]",
          "recipe[basenode::setup_firstboot]"
          ])
