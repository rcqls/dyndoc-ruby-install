module MongoidUtils
  def mongoid?(klass)
    Module.constants.include? :Mongoid and Module.constants.include? klass.to_sym
  end
end
