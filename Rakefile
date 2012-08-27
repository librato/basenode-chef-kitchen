require 'chef'

root_dir = File.dirname(__FILE__)
ROLE_DIR = File.join(root_dir, 'roles')

namespace :roles do
  desc "Convert ruby roles from ruby to json, creating/overwriting json files."
  task :to_json do
    Dir.glob(File.join(ROLE_DIR, '*.rb')) do |rb_file|
      role = Chef::Role.new
      role.from_file(rb_file)
      json_file = rb_file.sub(/\.rb$/,'.json')
      File.open(json_file, 'w'){|f| f.write(JSON.pretty_generate(role))}
    end
  end
end
