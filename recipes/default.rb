include_recipe 'apt'


apt_repository 'xion-packages' do
  uri node['openstack']['apt']['xion_uri']
  components ["cloudbau", "main"]
end
