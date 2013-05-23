# Inherit from this class to provide basic json ability 
# Initially taken from: http://stackoverflow.com/a/4464721/962890
#
# Improved it by supporting nested classes 
module JSONable
  def to_h
    hash = {
        json_class: self.class.name
    }
    self.instance_variables.each do |var|
      hashify hash, var
    end
    hash
  end

  def to_json(*a)
    hash = {
        json_class: self.class.name
    }
    self.instance_variables.each do |var|
      hashify hash, var
    end
    JSON.pretty_generate hash
  end

  def from_json!(str)
    JSON.load(str).each do |var, val|
      self.instance_variable_set var, val
    end
  end

  def self.json_create(o)
    inst = Object::const_get(o['json_class']).new
    o.delete('json_class')
    o.each do |var, val|

        inst.instance_variable_set '@'+var, create_from_val(val)
    end
    inst
  end

  private

  def self.create_from_val(val)
    if val.class == Array
      arr=[]
      val.each do |item|
        arr << create_from_val(item)
      end
      val=arr
    elsif val.class == Hash && val.has_key?('json_class')
      clazz = Object::const_get(val['json_class'])
      if clazz.respond_to? ('json_create')
        val= clazz.json_create(val)
      else
        val= json_create(val)
      end


    end
    val
  end



  def hashify hash, var
    value = instance_variable_get var
    key = var.to_s.delete '@'
    if value.is_a? Array
      hash[key] = value
    elsif value.respond_to? :to_json_value
      hash[key] = value.to_json_value
    elsif value.respond_to? :to_h
      hash[key] = value.to_h
    else
      hash[key] = value
    end
  end
end


class BigDecimal
  def to_h
    {
        json_class:'BigDecimal',
        value:self.to_s("F")
    }

  end
  def self.json_create(o)
    self.new(o['value'])
  end
end


class DateTime
  def to_h
    {
        json_class:'DateTime',
        second_from_epoch:self.to_time.to_i,
        descr:self.to_time.strftime('%d/%m/%Y')
    }


  end

  def self.json_create(o)

    DateTime.strptime(o['second_from_epoch'].to_s,'%s')
  end
end
