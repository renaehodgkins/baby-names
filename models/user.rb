class User
  include DataMapper::Resource

  attr_accessor :password, :password_confirmation
  
  property :id, Serial
  property :url, String
  property :email, String, :key => true, :nullable => false, :length => (5..40), :unique => true, :format => :email_address
  property :hashed_password, String
  property :salt, String, :nullable => false
  property :created_at, DateTime

  validates_present :password_confirmation, :unless => Proc.new { |t| t.hashed_password }
  validates_present :password, :unless => Proc.new { |t| t.hashed_password }
  validates_is_confirmed :password

  validates_is_unique :email

  has n, :accounts

  def self.authenticate(email, pass)
    return unless user = first(:email => email)
    user if User.encrypt(pass, user.salt) == user.hashed_password
  end  

  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) if !self.salt
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  private

    def self.encrypt(pass, salt)
      Digest::SHA1.hexdigest(pass+salt)
    end

    def self.random_string(len)
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      (1..len).collect { chars[rand(chars.size-1)] }.join
    end
end

