actions :update, :add, :remove
default_action :add

attribute :issuer, :kind_of => String
attribute :file, :required => true
