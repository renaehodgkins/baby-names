module RandomString
  def self.random(len=10)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    (1..len).collect { chars[rand(chars.size-1)] }.join
  end
end
