Puppet::Type.newtype(:foreman_organization) do
  desc 'foreman_organization registers a organization in foreman.'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the organization.'
    isrequired
  end
end
