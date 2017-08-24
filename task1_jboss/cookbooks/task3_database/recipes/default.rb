#
# Cookbook:: task3_database
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'mysql-community-repo' do
  command 'yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm -y'
  action :run
end

package 'net-tools' do
  action :install
end

mysql_service 'default' do
  version '5.7'
  bind_address '0.0.0.0'
  port '3306'
  initial_root_password 'vagrant'
  action [:create, :start]
end

bash 'create_database' do
  code <<-EOH
    mysql -S /var/run/mysql-default/mysqld.sock -uroot -pvagrant -e "create database task3 character set utf8 collate utf8_bin;"
    EOH
  not_if 'mysql -S /var/run/mysql-default/mysqld.sock -uroot -pvagrant -e "show databases" | grep task3'
end
