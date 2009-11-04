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

  def url=(new_url)
    attribute_set(:url, new_url.downcase)
  end

  def male_names
    names.all(:conditions => ['gender = ?', 'male'])
  end

  def female_names
    names.all(:conditions => ['gender = ?', 'female'])
  end
end

