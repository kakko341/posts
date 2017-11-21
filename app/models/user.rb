class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :posts
  has_many :retweets, dependent: :destroy
  has_many :retweet_posts, through: :retweets, source: :post
  
  def retweet(post)
    self.retweets.find_or_create_by(post_id: post.id)
  end

  def unretweet(post)
    retweet = self.retweets.find_by(post_id: post.id)
    retweet.destroy if retweet
  end
  
  def retweet?(post)
    self.retweet_posts.include?(post)
  end
  
  def feed_posts
    Post.where(user_id: self.post_ids + [self.id])
  end
  
  mount_uploader :image, ImageUploader
  
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
end
