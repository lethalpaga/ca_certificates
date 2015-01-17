#
# Cookbook Name:: ca_certificates
# Attributes:: default
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

default['ca_certificates']['issuer']['domain'] = 'vanzoest.com-2011'
default['ca_certificates']['caname'] = 'ca.vanzoest.com-2011'

# Where the various parts of ca root certificates are
case node['platform_family']
when 'rhel', 'fedora'
  # see update-ca-trust
  default['ca_certificates']['path'] = '/etc/pki/ca-trust/source/anchors'
when 'debian'
  # see update-ca-certificates
  default['ca_certificates']['path'] = '/usr/local/share/ca-certificates'
else
  default['ca_certificates']['path'] = nil
end
