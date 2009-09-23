class Name
  include DataMapper::Resource
  property :id,         Serial    # primary serial key
  property :gender,     String       
  property :name,       String,  :nullable => false # cannot be null
  property :created_at, DateTime
  property :updated_at, DateTime
  
  has n, :votes
  
  validates_present :gender, :name
  use Rack::Session::Cookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'
  
  def self.male
    all(:conditions => ['gender = ?', 'Male'])
  end

  def self.female
    all(:conditions => ['gender = ?', 'Female'])
  end
  
  def average_vote
    return unless votes.size > 0
    all_votes = votes.collect{|vote| vote.vote} # [5, 4, x, x, x]
    all_votes.inject(0) {|sum, value| sum += value}.to_f / votes.size
  end
end
