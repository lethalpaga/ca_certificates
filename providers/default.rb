# Support whyrun
def whyrun_supported?
  true
end

def load_current_resource
  new_resource.key new_resource.name unless new_resource.key
end

action :add do
  if platform_family?('debian')
    # see /usr/share/doc/ca-certificates/README.Debian
    # 1) copy ca in PEM format (extension .crt) to /usr/local/share/ca-certificates/local/
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
end

action :remove do
  if platform_family?('debian')
   # If you remove local certificates from /usr/local/share/ca-certificates/, you can remove symlinks by running
   # 'update-ca-certificates --fresh'.
  end
  if platform_family?('rhel')
  end
end
