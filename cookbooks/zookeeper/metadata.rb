maintainer       "Librato"
maintainer_email "jared@librato.com"
license          "Apache 2.0"
description      "Installs/Configures zookeeper"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.6"

supports         "ubuntu"

# XXX: Java 7?
depends          "java"
depends          "iptables"

# XXX: ZK Client?
recipe           "zookeeper::client", "Installs ZK client"
recipe           "zookeeper::server", "Installs ZK server"
