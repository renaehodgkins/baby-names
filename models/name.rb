class Name
  include DataMapper::Resource
  property :id,         Serial
  property :gender,     String       
  property :account_id, Integer
  property :name,       String,  :nullable => false
  property :created_at, DateTime
  property :updated_at, DateTime
  
  has n, :votes
  has n, :comments
  belongs_to :list
  
  validates_present :gender, :name
  
  def average_vote
    return unless votes.size > 0
    all_votes = votes.collect{|vote| vote.vote} # [5, 4, x, x, x]
    all_votes.inject(0) {|sum, value| sum += value}.to_f / votes.size
  end

  def percentage_vote
    average_vote.to_f / 5 * 100/1
  end
end
