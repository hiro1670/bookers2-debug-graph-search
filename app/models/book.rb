class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_one_attached :profile_image
  
  validates :title, presence: true
  validates :body, presence: true,length:{maximum:200}
  validates :tag, presence: :true
  
  def get_profile_image(width, height)
      unless profile_image.attached?
        file_path = Rails.root.join('app/assets/images/no_image.jpg')
        profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
      end
      profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  #7日間の記録
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
    scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
    scope :created_2day_ago, -> { where(created_at: 2.day.ago.all_day) }
    scope :created_3day_ago, -> { where(created_at: 3.day.ago.all_day) }
    scope :created_4day_ago, -> { where(created_at: 4.day.ago.all_day) }
    scope :created_5day_ago, -> { where(created_at: 5.day.ago.all_day) }
    scope :created_6day_ago, -> { where(created_at: 6.day.ago.all_day) }
  
  #記録機能
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
    scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
    scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
    scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }
  #並びかえ機能
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}
  
  #検索機能
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "before"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "back"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "part"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
end