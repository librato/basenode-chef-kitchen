#
# Install EC2 API tools
#

# multiverse
apt_repository "multiverse" do
  uri "http://us-east-1.ec2.archive.ubuntu.com/ubuntu"
  distribution node['lsb']['codename']
  components ["multiverse"]
  deb_src true
  action :add
end

# multiverse-updates
apt_repository "multiverse-updates" do
  uri "http://us-east-1.ec2.archive.ubuntu.com/ubuntu"
  distribution "#{node['lsb']['codename']}-updates"
  components ["multiverse"]
  deb_src true
  action :add
end

package "ec2-api-tools"
package "ec2-ami-tools"
