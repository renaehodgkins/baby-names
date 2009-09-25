class Comment
  include DataMapper::Resource
  property :id,         Serial    # primary serial key
  property :name_id,    Integer
  property :created_at, DateTime
  property :updated_at, DateTime
  property :body,   String
  
  belongs_to :name
  
end
