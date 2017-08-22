# # encoding: utf-8

# Inspec test for recipe task1_jboss::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('wildfly') do
  it { should be_enabled }
  it { should be_running }
end

describe command('curl -IL http://12.11.12.11:8080/') do
  its('stdout') { should match /200 OK/ }
end

describe command('curl -IL http://12.11.12.11:8080/helloworld/') do
  its('stdout') { should match /200 OK/ }
end

describe command('curl -IL http://12.11.12.11:8080/') do
  its('stdout') { should match /Server: WildFly/ }
end
