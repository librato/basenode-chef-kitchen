maintainer       "Librato"
maintainer_email "mike@librato.com"
license          "Apache 2.0"
description      "Installs/Configures Postfix in SMTP forward mode"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.2"

recipe "postfix", "Installs postfix"
recipe "postfix::forward", "Forward mail to an external SMTP"
