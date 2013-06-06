#
#
# XXX: this only supports 0 at the current time
default[:ec2][:raid_level] = 0
default[:ec2][:raid_read_ahead] = 512
default[:ec2][:raid_mount] = "/raid0"

# EC2 AMI tools

default[:ec2][:ami_tools_version] = "1.4.0.9"
default[:ec2][:ami_tools_url] = "http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip"
default[:ec2][:ami_tools_sha] = "9876de865e55053578d5d716d4325166262f7ee9e965e2987103b21b45969745"
default[:ec2][:ami_tools_install_dir] = "/opt"

# Java DNS TTL
default[:ec2][:java_dns_ttl] = 0
