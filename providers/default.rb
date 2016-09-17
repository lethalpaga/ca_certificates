# Support whyrun
def whyrun_supported?
  true
end

def load_current_resource
  # This looks half-baked and is not used below anyway
  # new_resource.key new_resource.name unless new_resource.key
end

action :add do
  if platform_family?('debian')
    # see /usr/share/doc/ca-certificates/README.Debian
    # 1) copy ca in PEM format (extension .crt) to /usr/local/share/ca-certificates/
    #
    directory "#{node['ca_certificates']['path']}/local" do
      owner 'root'
      group 'root'
      mode '0700'
      action :create
    end

    if new_resource.file
      cookbook_file "#{node['ca_certificates']['path']}/#{node['ca_certificates']['caname']}.crt" do
        source "certs/#{node['ca_certificates']['caname']}.crt"
        owner 'root'
        group 'root'
        mode '0600'
        action :create
      end
    elsif new_resource.content
      file "#{node['ca_certificates']['path']}/local/#{new_resource.cert_name}.crt" do
        content new_resource.content
        owner 'root'
        group 'root'
        mode '0600'
        action :create
      end
    else
      fail 'Please specify either file or content'
    end

    # 2) edit /etc/ca-certificates.conf
    ruby_block "add #{new_resource.cert_name} to /etc/ca-certificates.conf" do
      block do
        fe = Chef::Util::FileEdit.new('/etc/ca-certificates.conf')
        fe.insert_line_if_no_match(/^local\/#{new_resource.cert_name}.crt$/, "local/#{new_resource.cert_name}.crt")
        fe.write_file
      end
      not_if "grep #{new_resource.cert_name} /etc/ca-certificates.conf"
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
    execute 'update-ca-trust enable' do
      action :run
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
