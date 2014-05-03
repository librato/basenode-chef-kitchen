name "java"
description "Install Oracle Java VM"

default_attributes({
                     :java => {
                       :install_flavor => 'oracle',
                       :arch => "x86_64",
                       :jdk => {
                         "7" => {
                           :x86_64 => {
                             :url => "http://s3.amazonaws.com/librato_download/chef/jdk1.7.0_55.tar.gz",
                             :checksum => "86f8c25718801672b7289544119e7909de82bb48393b78ae89656b2561675697"
                           }
                         },
                         "8" => {
                           :x86_64 => {
                             :url => "http://s3.amazonaws.com/librato_download/chef/jdk1.8.0_05.tar.gz",
                             :checksum => "44901389e9fb118971534ad0f58558ba8c43f315b369117135bd6617ae631edc"
                           }
                         }
                       }
                     }
                   })

run_list([
          "recipe[java]",
          "recipe[ec2::java_dns_ttl]"
         ])
