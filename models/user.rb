# Extending User which is defined in gem sinatra-authentication
class User
  property :url, String
  has n, :accounts

  validates_is_unique :email, :url
end

#user must be able to sign up for new account, linked to email address/password, have their page generate a unique url to give to friends and family, be able to delete names or comments, display winning name, choose a gender or leave it as unknown, add another baby page (craete another unique url for subsequent babies). 