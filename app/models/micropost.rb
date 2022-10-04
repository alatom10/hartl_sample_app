class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) } #this sets the default scope. the way in which data is pulled from the db. the '->' is called as stabby lambda. Basically a lambda/arrow function ?
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
 
end
