class Vote
  include DataMapper::Resource
  property :id,         Serial    # primary serial key
  property :name_id,    Integer
  property :ip,         String
  property :vote,       Integer
  property :created_at, DateTime
  property :updated_at, DateTime
  
  belongs_to :name
  
  validates_uniqueness_of :ip, :scope => :name_id
  validates_within :vote, :set => (1..5)
end
