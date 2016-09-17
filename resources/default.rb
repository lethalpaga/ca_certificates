actions :update, :add, :remove
default_action :add

attribute :issuer, :kind_of => String

attribute :cert_name, name_attribute: true

# Either file or content should be provided
attribute :file
attribute :content
