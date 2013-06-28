#
# Cookbook Name:: rails_app
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user_name = node[:rails_app][:user]
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

app_name  = node[:rails_app][:name]
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
