class Question < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true, length: { maximum: 1000 }

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable
end
