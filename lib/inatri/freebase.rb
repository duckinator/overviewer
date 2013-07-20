class Freebase
  def initialize(*args)
    if args.all? {|x| x.is_a?(Hash) }
      
    else
      raise ArgumentError, "expected Hash, got #{args.map(&:class).reject{|x|x==Hash}.first}"
    end
  end
end
