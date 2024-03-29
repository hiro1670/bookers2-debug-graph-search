class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  
  has_many :favorites, dependent: :destroy
  
  has_many :book_comments, dependent: :destroy
  
  has_many :followeds, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  
  has_many :following_users, through: :followers, source: :followed
  has_many :follower_users, through: :followeds, source: :follower

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction,    length: { maximum: 50 }
  
  def get_profile_image(width, height)
      unless profile_image.attached?
        file_path = Rails.root.join('app/assets/images/no_image.jpg')
        profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
      end
      profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def is_followed_by?(user)
    reverse_of_relationships.find_by(following_id: user.id).present
  end
  
  def follow(user_id)
    followers.create(followed_id: user_id)
  end
  
  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end
  
  def following?(user)
    following_users.include?(user)
  end
  
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "before"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "back"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "part"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
end