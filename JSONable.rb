# Inherit from this class to provide basic json ability 
# Initially taken from: http://stackoverflow.com/a/4464721/962890
#
# Improved it by supporting nested classes 
class JSONable
  def to_hash
    hash = {}
    instance_variables.each do |var|
      hashify hash, var
    end
    hash
  end

  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hashify hash, var
    end
    hash.to_json
  end

  #def from_json! string
  #  JSON.load(string).each do |var, val|
  #    self.instance_variable_set var, val
  #  end
  #end
  
  private

  def hashify hash, var
    value = instance_variable_get var
    key = var.to_s.delete '@'
    if value.is_a? Array
      hash[key] = value
    elsif value.respond_to? :to_hash
      hash[key] = value.to_hash
    else
      hash[key] = value.to_s      
    end
  end
end
