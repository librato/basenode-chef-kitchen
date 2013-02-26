name "java"
description "Install Oracle Java VM"

default_attributes({
                     :java => {
                       :install_flavor => 'oracle',
                       :jdk => {
                         "6" => {
                           :x86_64 => {
                             :url => "http://s3.amazonaws.com/librato_download/chef/jdk-6u41-linux-x64.bin"
                           }
                         }
                       }
                     }
                   })

run_list(["recipe[java]"])
