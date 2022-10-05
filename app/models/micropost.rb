class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image #pg 798 using upload images
  default_scope -> { order(created_at: :desc) } #this sets the default scope. the way in which data is pulled from the db. the '->' is called as stabby lambda. Basically a lambda/arrow function ?
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size:         { less_than: 5.megabytes,
                                    message:   "should be less than 5MB" }

                                    # Returns a resized image for display.
  def display_image 
    image.variant(resize_to_limit: [500, 500])
  end
    
end
