class FunctionalHash < Hash
  def [](*args)
    key = args.shift
    if fetch(key).is_a? Proc
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
end
