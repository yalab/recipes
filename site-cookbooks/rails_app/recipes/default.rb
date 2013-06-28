#
# Cookbook Name:: rails_app
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'database::mysql'
include_recipe "database"

app_name  = node[:rails_app][:name]
user_name = node[:rails_app][:user]

db = {
  host:     "localhost",
  username: 'root',
  password: node['mysql']['server_root_password']
}

mysql_database app_name do
  connection db
  action :create
end

mysql_database_user node['rails_app']['mysql']['user'] do
  connection db
  password node['rails_app']['mysql']['password']
  database_name app_name
  privileges [:all]
  action [:create, :grant]
end

home_dir = "/home/#{user_name}"
user user_name do
  action :create
  shell "/bin/bash"
  home home_dir
end

directory home_dir do
  owner user_name
  group user_name
  mode  '0701'
end

directory "#{home_dir}/rails_app/shared/system" do
  owner user_name
  group user_name
  mode  '0701'
  recursive true
end

template "/etc/nginx/sites-enabled/#{app_name}.conf" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, 'service[nginx]'
end

template "#{home_dir}/rails_app/shared/system/database.yml" do
  source "database.yml.erb"
  owner user_name
  group user_name
  mode 0600
end
