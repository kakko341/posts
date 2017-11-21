class Post < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
  
  has_many :retweets, dependent: :destroy
  has_many :retweet_users, through: :retweets, source: :user
  
  mount_uploader :image, ImageUploader
  # has_many :images, dependent: :destroy
  
end
