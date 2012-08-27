name "ssh"
description "SSH firewall ports"

default_attributes({
                     :misc => {
                       :ssh_firewall => {
                         :window => 20,
                         :max_conns => 15,
                         :port => 22
                       }
                     }
                   })

run_list(["recipe[misc::ssh_firewall]"])
