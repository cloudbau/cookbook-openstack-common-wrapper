normal[:openstack][:release] = 'havana'
normal[:openstack][:apt][:components] = [ 'precise-updates/havana', 'main' ]

default['openstack']['apt']['xion_uri'] = "http://xion-repo.s3.amazonaws.com/havana-extreme/repo"
