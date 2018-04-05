Puppet::Type.type(:foreman_organization).provide(:rest_v3, :parent => Puppet::Type.type(:foreman_resource).provider(:rest_v3)) do
  confine :feature => [:json, :oauth]

  def organization
    @organization ||= begin
      r = request(:get, 'api/v2/organizations', :search => %{name="#{resource[:name]}"})
      raise Puppet::Error.new("Organization #{resource[:name]} cannot be retrieved: #{error_message(r)}") unless success?(r)
      JSON.load(r.body)['results'][0]
    end
  end

  def id
    organization ? organization['id'] : nil
  end

  def exists?
    !id.nil?
  end

  def create
    post_data = {:organization => {:name => resource[:name]}}.to_json
    r = request(:post, 'api/v2/organizations', {}, post_data)
    raise Puppet::Error.new("Organization #{resource[:name]} cannot be registered: #{error_message(r)}") unless success?(r)
  end

  def destroy
    r = request(:delete, "api/v2/organizations/#{id}")
    raise Puppet::Error.new("Organization #{resource[:name]} cannot be removed: #{error_message(r)}") unless success?(r)
    @proxy = nil
  end
end
