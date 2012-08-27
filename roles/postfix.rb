name "postfix"
description "Forward local mail via postfix"

default_attributes({
                     :postfix => {
                       :smtp_host => "",
                       :sasl_user => "",
                       :sasl_password => ""
                     },
                   })

run_list(["recipe[postfix::forward]"])
