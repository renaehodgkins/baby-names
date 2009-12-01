class Comment
  include DataMapper::Resource
  property :id,         Serial    # primary serial key
  property :name_id,    Integer
  property :list_id,    Integer
  property :created_at, DateTime
  property :updated_at, DateTime
  property :body_heroku,Text
  property :author,     String
  
  belongs_to :name

  def author=(new_author)
    super unless new_author.blank?
    attribute_set(:author, 'anonymous')
  end
end
