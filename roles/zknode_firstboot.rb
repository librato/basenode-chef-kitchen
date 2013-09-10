name "zknode_firstboot"
description "Zk node firstboot"

attrs = {
  :java => {
    :install_flavor => 'oracle',
    :jdk => {
      "6" => {
        :x86_64 => {
          :url => "http://s3.amazonaws.com/librato_download/chef/jdk-6u41-linux-x64.bin"
        }
      }
    }
  },
  :zookeeper => {
    :max_heap => "1G"
  }
}

default_attributes(attrs)

run_list(["recipe[zknode::firstboot]"
          ])
