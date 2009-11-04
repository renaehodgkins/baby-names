class Name
  include DataMapper::Resource

  property :id,             Serial
  property :gender,         String       
  property :list_id,        Integer
  property :root_name_id, Integer
  property :name,           String,  :nullable => false
  property :created_at,     DateTime
  property :updated_at,     DateTime
  
  has n, :votes
  has n, :comments

  belongs_to :list
  belongs_to :root_name
  
  validates_present :gender, :name

  def name=(new_name)
    attribute_set(:name, new_name.capitalize)
  end

  before :create do |name|
    root_name = RootName.all(:name => self.name, :gender => self.gender).first || RootName.create(:name => self.name, :gender => self.gender)
    self.root_name_id = root_name.id
  end

  after :create do |name|
    root_name.names_count = root_name.names_count += 1
    root_name.save
  end
  
  before :destroy do |name|
    root_name.names_count = root_name.names_count -= 1
    root_name.save

    comments.each {|comment| comment.destroy}
    votes.each {|vote| vote.destroy}
  end

  def average_vote
    return unless votes.size > 0
    all_votes = votes.collect{|vote| vote.vote} # [5, 4, x, x, x]
    all_votes.inject(0) {|sum, value| sum += value}.to_f / votes.size
  end

  def percentage_vote
    average_vote.to_f / 5 * 100/1
  end
end
