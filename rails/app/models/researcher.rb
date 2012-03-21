class Researcher < ActiveRecord::Base

  has_many :curations
  has_many :posts
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.oauth_token = auth["credentials"]["token"]
      user.oauth_token_secret = auth["credentials"]["secret"]
      user.user_name = auth["info"]["nickname"]
      user.name = auth["info"]["name"]
      user.first_time = true
    end
  end

  def twitter_url
    "http://twitter.com/#{self.user_name}"
  end

  def twitter_pic(size)
    # :bigger, :normal, :mini, :original
    "https://api.twitter.com/1/users/profile_image?screen_name=#{self.user_name}&size=#{size.to_s}"
  end

  def to_param
    self.user_name
  end
  
  def human_join_date
    return self.join_date.strftime("%b %d, %Y")
  end
  
  def self.roles
    return ["Inactive", "Suspended", "User", "Academic", "Admin"]
  end
  
  def admin?
    return Researcher.find(self.id).role == "Admin"
  end
end
