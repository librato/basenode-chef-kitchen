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
#package "ec2-ami-tools"
#
# Install latest AMI tools from S3. APT version is too old.
#

# This is needed by the latest ec2-ami-tools (1.5.2)
package "kpartx"

directory "/opt/src" do
  action :create
  recursive true
end

remote_file "/opt/src/ec2-ami-tools.zip" do
  source node[:ec2][:ami_tools_url]
  checksum node[:ec2][:ami_tools_sha]
  mode "0644"
end

dir = File.join(node[:ec2][:ami_tools_install_dir],
                "ec2-ami-tools-#{node[:ec2][:ami_tools_version]}")
package "unzip"
bash "unzip-ec2-ami-tools" do
  code <<EOH
unzip -o /opt/src/ec2-ami-tools.zip -d #{node[:ec2][:ami_tools_install_dir]}
EOH
  creates dir
end

# XXX: Copy utilities to /usr/bin and set tool directory
ruby_block "install_ami_tools" do
  block do
    Dir.glob("#{dir}/bin/*").each do |f|
      base = File.basename(f)
      File.open("/usr/bin/#{base}", "w", 0755) do |wf|
        File.readlines(f).each do |l|
          wf.print l
          if l =~ /^#!\/bin\/bash/
            wf.puts "export EC2_AMITOOL_HOME=#{dir}"
          end
        end
      end
    end
  end

  not_if {File.exists?("/usr/bin/ec2-bundle-vol")}
end
