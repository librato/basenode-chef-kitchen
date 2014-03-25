name "statsite"
description "Install statsite for application metrics"

# %% variables are replaced at boot with runtime parameters
default_attributes({
                     :statsite => {
                       :repo => "https://github.com/librato/statsite.git",
                       :ref => "feature/librato",
                       :service_type => "upstart",
                       :flush_interval => "%%INTERVAL%%",
                       :stream_command => "python /opt/statsite/sinks/librato.py /etc/statsite/librato.conf",
                     },
                     :statsite_librato => {
                       :email => '%%EMAIL%%',
                       :token => '%%TOKEN%%',
                       :api => '%%API%%',
                       :source => '%%HOSTNAME%%',
                       :source_regex => '/^([^-]+)--/',
                       :floor_time_secs => "%%INTERVAL%%",
                     },
                   })

run_list(["recipe[statsite]",
          "recipe[basenode::statsite]"
         ])
