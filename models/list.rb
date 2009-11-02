class List
  include DataMapper::Resource
  property :id,         Serial
  property :user_id,    Integer       
  property :url,        String

  belongs_to :user
  has n, :names

  validates_is_unique :url

  before :create do
    self.url = String.random(7).downcase
  end
end

