#
#
# XXX: this only supports 0 at the current time
default[:ec2][:raid_level] = 0
default[:ec2][:raid_read_ahead] = 65536
default[:ec2][:raid_mount] = "/raid0"

# EC2 AMI tools

default[:ec2][:ami_tools_version] = "1.4.0.7"
default[:ec2][:ami_tools_url] = "http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip"
default[:ec2][:ami_tools_sha] = "376204b297d104a07c0011e81f98a3f91457a46c4c0833135c60f01087300c51"
default[:ec2][:ami_tools_install_dir] = "/opt"
