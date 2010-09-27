module ModelOverride
  def get(*keys)
    keys = keys.collect {|k| k.to_i}
    super
  end
end

DataMapper::Model.append_extensions(ModelOverride)

