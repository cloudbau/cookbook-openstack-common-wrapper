include_recipe "openstack-common::set_endpoints_by_interface"

# Fix database host ip.
db_interface = node['openstack']['db']['bind_interface']
unless db_interface.nil?
  ip_address = address_for db_interface
  components = node['openstack']['db'].select { |k, v| v.include? "host" }.keys
  components.each do |component|
    node.default['openstack']['db'][component]['host'] = ip_address
  end
end

# Fix rabbit host ip.
mq_interface = node['mq']['bind_interface']
unless mq_interface.nil?
  ip_address = address_for mq_interface
  components = node['openstack'].select {
      |k, v| v.include? "rabbit" and v["rabbit"].include? "host"
  }.keys
  components.each do |component|
    node.default['openstack'][component]['rabbit']['host'] = ip_address
  end
end
