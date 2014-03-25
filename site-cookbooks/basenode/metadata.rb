maintainer       "YOUR_COMPANY_NAME"
maintainer_email "YOUR_EMAIL"
license          "All rights reserved"
description      "Installs/Configures basenode"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "basenode", "Basenode recipes"
recipe "basenode::setup_firstboot", "Setup firstboot script"
recipe "basenode::firstboot", "Firstboot scripts"
recipe "basenode::add_users", "Add users on boot"
recipe "basenode::iptables", "Set iptables on boot"
recipe "basenode::statsite", "Setup statsite config files"
