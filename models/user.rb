class User
  include DataMapper::Resource

  attr_accessor :password, :password_confirmation
  
  property :id,               Serial
  property :hashed_password,  String
  property :salt,             String, :required => true
  property :created_at,       DateTime
  property :email,            String, :key => true, :required => true, 
                                      :length => (5..40), :unique => true, 
                                      :format => :email_address

  validates_presence_of :password_confirmation, :unless => Proc.new { |t| t.hashed_password }
  validates_presence_of :password, :unless => Proc.new { |t| t.hashed_password }
  validates_confirmation_of :password

  validates_uniqueness_of :email

  has n, :lists

  def self.authenticate(email, pass)
    return unless user = first(:email => email)
    user if User.encrypt(pass, user.salt) == user.hashed_password
  end  

  def password=(pass)
    @password = pass
    self.salt = String.random(10) if !self.salt
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  private
    def self.encrypt(pass, salt)
      Digest::SHA1.hexdigest(pass+salt)
    end
end

