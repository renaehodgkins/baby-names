# Extending User which is defined in gem sinatra-authentication
class User
  property :url, String
  has n, :accounts

  validates_is_unique :email, :url
end

