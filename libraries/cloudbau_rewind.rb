# Custom rewind that take at the opposite of chef/rewind doesn't
# assume that there is no duplicate resource, instead it will
# "rewind" all resources with name `resource_id`.
def cloudbau_rewind(resource_id, &block)
  run_context.resource_collection.each {
    |r| r.instance_exec(&block) if block and r.to_s == resource_id
  }
end
