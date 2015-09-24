
default[:zookeeper][:group] = "zookeeper"
default[:zookeeper][:user] = "zookeeper"

default[:zookeeper][:conf_dir] = '/etc/zookeeper'
default[:zookeeper][:data_dir] = '/var/lib/zookeeper'
default[:zookeeper][:log_dir] = '/var/log/zookeeper'

default[:zookeeper][:max_heap] = "512m"

default[:zookeeper][:version] = "3.4.6"
default[:zookeeper][:checksum] = "01b3938547cd620dc4c93efe07c0360411f4a66962a70500b163b59014046994"
# Must confirm to $URL/zookeeper-<version>/zookeeper-<version>.tar.gz
default[:zookeeper][:mirror] = "http://mirrors.ibiblio.org/apache/zookeeper"

default[:zookeeper][:tick_time] = 2000
default[:zookeeper][:init_limit] = 10
default[:zookeeper][:sync_limit] = 5
default[:zookeeper][:client_port] = 2181
default[:zookeeper][:quorum_port] = 2888
default[:zookeeper][:leader_elect_port] = 3888
default[:zookeeper][:max_client_connections] = 100

default[:zookeeper][:snap_retain_count] = 14
default[:zookeeper][:purge_interval] = 24

# How long to cache DNS entries (JVM option)
default[:zookeeper][:dns_cache_ttl] = 60

# Set to the global list of server IPs.
#
default[:zookeeper][:servers] = nil

# XXX: This must be set to the integer index (zero-based)
# in the servers list.
#
default[:zookeeper][:myid] = nil

