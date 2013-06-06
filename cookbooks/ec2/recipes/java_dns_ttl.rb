#
# Unset the ridiculous Java DNS TTL caching.
# See: http://www.vertigrated.com/blog/2009/11/disable-default-java-dns-caching/
#

ruby_block "set_java_dns_ttl" do
  block do
    ret = true
    Dir['/usr/lib/jvm/**/jre/lib'].each do |dir|
      secfile = File.join(dir, "security/java.security")
      if File.exist?(secfile)
        r = system("sed -i -e 's/^.*networkaddress.cache.ttl=.*$/networkaddress.cache.ttl=#{node[:ec2][:java_dns_ttl]}/g' #{secfile}")
        unless r
          ret = false
          break
        end
      end
    end
    ret
  end
end
