class FunctionalHash < Hash
  def [](*args)
    key = args.shift
    if fetch(key, nil).is_a? Proc
      if fetch(key).arity == 0
        fetch(key).call
      else
        args.unshift(self)
        fetch(key).call(*args)
      end
    else
      super(key)
    end
  end

  def self.enable!
    unless Hash.respond_to? :fn
      Hash.class_eval do
        def fn
          FunctionalHash.new.tap do |fh|
            self.each do |key, val|
              fh[key] = val
            end
          end
        end
      end
    end
  end

  def self.disable!
    if Hash.instance_methods.include? :fn
      Hash.class_eval { undef_method :fn }
    end
  end

  def self.from_hash(hash)
    raise ArgumentError, 'FunctionalHash.from_hash requires a Hash' unless hash.is_a? Hash
    new.tap do |fn_hash|
      hash.each { |k, v| fn_hash[k.dup] = v.dup }
    end
  end
end
