class Activedap < ActiveLdap::Base
  def _dump level = 0
    [dn.to_s, attributes].to_s
  end

  # Create a new instance of the correct class from given DN and attributes
  def self._load data
    dn, attributes = eval data
    obj = self.ancestors[0].allocate
    obj.instance_eval do
      initialize_by_ldap_data(dn, attributes)
    end
    obj
  end

  def cache_key
    raise "cache_key: Implement in sub-class"
  end
end
