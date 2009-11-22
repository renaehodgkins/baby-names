class List
  include DataMapper::Resource
  property :id,         Serial
  property :user_id,    Integer       
  property :url,        String
  property :gender,     String

  belongs_to :user
  has n, :names
  
  validates_present :url
  validates_length :url, :min => 4
  validates_is_unique :url, :message => "Url is already in use, please choose a unique url"
  validates_present :gender, :message => "Please select a gender"
  
  before :create do
    self.url ||= String.random(7).downcase
  end

  def to_param
    "#{id}-#{url}"
  end

  def url=(new_url)
    attribute_set(:url, new_url.downcase.gsub(/\W/, '-'))
  end

  def male_names
    names.all(:conditions => ['gender = ?', 'male'])
  end

  def female_names
    names.all(:conditions => ['gender = ?', 'female'])
  end

  def male?
    gender == 'male'
  end

  def female?
    gender == 'female'
  end

  def both?
    gender == 'both'
  end

  before :destroy do |list|
    names.each {|name| name.destroy }
  end
end

