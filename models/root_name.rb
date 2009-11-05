class RootName
  include DataMapper::Resource
  property :id,          Serial
  property :name,        String,  :nullable => false
  property :gender,      String       
  property :names_count, Integer, :default => 0
  property :created_at,  DateTime
  property :updated_at,  DateTime

  has n, :names

  validates_present :gender, :name

  def average_vote
    all_votes = names.collect{|name| name.average_vote}.compact
    return 0.0 if all_votes.empty?
    all_votes.inject(0) {|sum, value| sum += value}.to_f / all_votes.size
  end

  def lists
    names.collect {|name| name.list }.compact
  end
end
