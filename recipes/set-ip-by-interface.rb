class ::Chef::Recipe
  include ::Openstack
end

controller_node = search(:node, "role:os-compute-single-controller").first

# Fix endpoints ip.
unless controller_node.nil?
  node['openstack']['endpoints'].keys.each do |component|
    node.default['openstack']['endpoints'][component]['host'] = \
      controller_node['openstack']['endpoints'][component]['host']
  end
else
  node['openstack']['endpoints'].keys.each do |component|
    cp_interface = node['openstack']['endpoints'][component]['bind_interface']
    unless cp_interface.nil?
      ip_address = address_for cp_interface
      node.default['openstack']['endpoints'][component]['host'] = ip_address
    end
  end
end

# Fix database host ip.
components = node['openstack']['db'].select {
  |k, v| v.include? "host" rescue false
}.keys
unless controller_node.nil?
  components.each do |component|
    node.default['openstack']['db'][component]['host'] = \
      controller_node['openstack']['db'][component]['host']
  end
else
  db_interface = node['openstack']['db']['bind_interface']
  unless db_interface.nil?
    ip_address = address_for db_interface
    components.each do |component|
      node.default['openstack']['db'][component]['host'] = ip_address
    end
  end
end

# Fix rabbit host ip.
components = node['openstack'].select {
  |k, v| (v.include? "rabbit" and v["rabbit"].include? "host") rescue false
}.keys
unless controller_node.nil?
    components.each do |component|
      node.default['openstack'][component]['rabbit']['host'] = \
        controller_node['openstack'][component]['rabbit']['host']
    end
else
  mq_interface = node['openstack']['mq']['bind_interface']
  unless mq_interface.nil?
    ip_address = address_for mq_interface
    components.each do |component|
      node.default['openstack'][component]['rabbit']['host'] = ip_address
    end
  end
end
