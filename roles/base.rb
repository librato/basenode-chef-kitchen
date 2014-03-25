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
      "net.core.netdev_max_backlog" => 2048,
      "net.core.rmem_max" => 16777216,
      "net.core.wmem_max" => 16777216,
      "net.ipv4.tcp_rmem" => "4096 65536 16777216",
      "net.ipv4.tcp_wmem" => "4096 65536 16777216",
      "vm.max_map_count" => 1048575,
      "fs.file-max" => 1048575
    }
  }
}

default_attributes(attrs)

run_list(["recipe[apt]",
          "recipe[misc::apt_update]",
          "recipe[misc::apt_upgrade]",
          "recipe[misc::github_whitelist]",
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
          "role[statsite]",
          "role[papertrail]",
          "role[java]",
          "recipe[basenode::setup_firstboot]"
          ])
