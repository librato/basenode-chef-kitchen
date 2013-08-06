include_recipe 'users'

node[:basenode][:add_users].each do |username, params|
  create_user username do
    details params
  end
end
