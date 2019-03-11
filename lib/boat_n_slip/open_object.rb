require 'ostruct'

class OpenObject < OpenStruct

  def initialize(data = {})
    super data
    data.each { |k, v| send "#{k}=", v }
  end

  # I choose to match on /^.*=/ so that it can provide custom error handling
  # when #method_missing is called
  def method_missing(name, *args, &block)
    if /^.*=/.match?(name) && !args[0].nil?
      super
    elsif error_mapping.keys.include? name.to_sym
      raise error_mapping[name.to_sym]
    else
      raise NoMethodError,
            "undefined method `#{name}' for #{self}:#{self.class}"
    end
  end

  def respond_to_missing?(mid, include_private = false)
    @table.key?(mid.to_s.chomp('=').to_sym) || super
  end

  # when one of the keys method names gets called if method missing is invoked
  # then the exception is thrown. This could prove to be unstable
  def error_mapping
    {}
  end

end

