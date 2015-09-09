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
                             :url => "http://s3.amazonaws.com/librato_download/chef/jdk1.8.0_60.tar.gz",
                             # sha256
                             :checksum => "ebe51554d2f6c617a4ae8fc9a8742276e65af01bd273e96848b262b3c05424e5"
                           }
                         }
                       }
                     }
                   })

run_list([
          "recipe[java]",
          "recipe[ec2::java_dns_ttl]"
         ])
