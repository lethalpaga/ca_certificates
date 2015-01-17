# Cookbook Name:: ca_certificates
# Recipe:: default
#
# Copyright 2015, Alexander van Zoest
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
#

package 'ca-certificates' do
  action :install
  only_if { platform_family?('debian', 'rhel') }
end

directory node['ca_certificates']['path'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

if platform_family?('debian')
  # see /usr/share/doc/ca-certificates/README.Debian
  # 1) copy ca in PEM format (extension .crt) to /usr/local/share/ca-certificates/local
  cookbook_file "#{node['ca_certificates']['path']}/#{node['ca_certificates']['caname']}.crt" do
    source "certs/#{node['ca_certificates']['caname']}.crt"
    owner 'root'
    group 'root'
    mode '0600'
    action :create
  end
  # 2) edit /etc/ca-certificates.conf
  ruby_block "add #{node['ca_certificates']['caname']} to /etc/ca-certificates.conf" do
    block do
      fe = Chef::Util::FileEdit.new('/etc/ca-certificates.conf')
      fe.insert_line_if_no_match(/^local\/#{node['ca_certificates']['caname']}.crt$/, "local/#{node['ca_certificates']['caname']}.crt")
      fe.write_file
    end
    not_if "grep #{node['ca_certificates']['caname']} /etc/ca-certificates.conf"
  end
  # 3) run update-ca-certificates
  execute 'update-ca-certificates' do
    action :run
  end
end

if platform_family?('rhel')
  # see /etc/pki/ca-trust/source/README
  # see /usr/share/pki/ca-trust-source/README
  # see man update-ca-trust
  # 1) copy ca in PEM format to /etc/pki/ca-trust/source/anchors
  # 2) run update-ca-trust
  cookbook_file "#{node['ca_certificates']['path']}/#{node['ca_certificates']['caname']}.pem" do
    source "certs/#{node['ca_certificates']['caname']}.crt"
    owner 'root'
    group 'root'
    mode '0600'
    action :create
  end
  execute 'update-ca-trust extract' do
    action :run
  end
end
