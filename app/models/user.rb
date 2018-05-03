class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  devise :omniauthable, :omniauth_providers => [:instagram]

  has_many :posts, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "#{auth.extra['raw_info']['username']}@instagram.com"
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.image = auth.info.image
      user.token = auth.credentials.token
    end
  end

  def User.fetch_instagram_posts
    find_each do | user |
      response = HTTParty.get("https://api.instagram.com/v1/users/self/media/recent?access_token=#{user.token}")
      response['data'].each do |data|
        post = user.posts.where(instagram_post_id: data['id']).first_or_initialize
        post.comments_count = data['comments']['count']
        post.link = data['images']['standard_resolution']['url']
        post.likes_count = data['likes']['count']         
        post.save!
      end
    end    
  end


end
