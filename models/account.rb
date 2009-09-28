class Account
  include DataMapper::Resource
  property :id,         Serial
  property :user_id,    Integer       

  belongs_to :user
  has n, :names
end

