class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :comments

  authenticates_with_sorcery!


  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  validates :email, uniqueness: true
end
