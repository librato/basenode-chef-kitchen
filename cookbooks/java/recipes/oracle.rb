#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Cookbook Name:: java
# Recipe:: oracle
#
# Copyright 2011, Bryan w. Berry
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


java_home = node['java']["java_home"]
arch = node['java']['arch']

file "/etc/profile.d/jdk.sh" do
  content <<-EOS
    export JAVA_HOME=#{node['java']["java_home"]}
  EOS
  mode 0755
end

node['java']['jdk'].each do |jdk_version, arch_hash|
  tarball_url = arch_hash[arch]['url']
  tarball_checksum = arch_hash[arch]['checksum']

  ruby_block  "set-env-java#{jdk_version}-home" do
    block do
      ENV["JAVA_HOME"] = java_home
    end
  end

  java_ark "jdk#{jdk_version}" do
    url tarball_url
    checksum tarball_checksum
    app_home java_home
    link "#{java_home}/../jdk#{jdk_version}"  # XXX: reference JVM's by version
    bin_cmds ["java", "jar"]
    action :install
  end
end
