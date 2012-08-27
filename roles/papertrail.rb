name "papertrail"
description "System logging to papertrailapp.com"

default_attributes({
                     :papertrail => {
                       :remote_port => 0,
                       :hostname_cmd => "hostname",
                       :watch_files => {
                       }
                     },
                   })

run_list(["recipe[papertrail]"])
