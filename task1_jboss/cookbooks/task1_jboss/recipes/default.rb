#
# Cookbook:: task1_jboss
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
package 'unzip' do
  action :install
end
package 'java-1.8.0-openjdk-devel.x86_64' do
  action :install
end
package 'net-tools' do
  action :install
end

#startup  and service enable
template '/etc/systemd/system/wildfly.service' do
  source 'wildfly.service.erb'
  owner 'root'
  group 'root'
  mode '0755'
end
bash 'place_wildfly' do
  code <<-EOH
    unzip /tmp/chef-pkgs/wildfly-10.1.0.Final.zip
    cp -rf /tmp/chef-pkgs/wildfly-10.1.0.Final /opt/wildfly-10.1.0.Final
    chmod +x /opt/wildfly-10.1.0.Final/bin/*.sh
    EOH
  not_if { ::File.exist?('/opt/wildfly-10.1.0.Final') }
end

#Standalone config
template '/opt/wildfly-10.1.0.Final/bin/standalone.conf' do
  source 'standalone.conf.erb'
end

#Users and roles
template '/opt/wildfly-10.1.0.Final/standalone/configuration/application-roles.properties' do
  source 'application-roles.properties.erb'
end
template '/opt/wildfly-10.1.0.Final/standalone/configuration/application-users.properties' do
  source 'application-users.properties.erb'
end
template '/opt/wildfly-10.1.0.Final/standalone/configuration/mgmt-groups.properties' do
  source 'mgmt-groups.properties.erb'
end
template '/opt/wildfly-10.1.0.Final/standalone/configuration/mgmt-users.properties' do
  source 'mgmt-users.properties.erb'
end

#Deploying
bash 'deploy_application' do
  code <<-EOH
    cp -f /tmp/chef-pkgs/helloworld.war /opt/wildfly-10.1.0.Final/standalone/deployments/
    EOH
  not_if { ::File.exist?('/opt/wildfly-10.1.0.Final/standalone/deployments/helloworld.war') }
end
service 'wildfly' do
  action [ :enable, :start ]
  supports :reload => true
end

bash 'wait_60_seconds' do
  code <<-EOH
    sleep 30
    EOH
end