class Comment < ActiveRecord::Base
  belongs_to :answer
  belongs_to :question

  validates :body, presence: true, length: { maximum: 1000 }
end
