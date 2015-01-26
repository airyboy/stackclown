# create_table :users, force: true do |t|
#   t.string   :email,                                   null: false
#   t.string   :crypted_password,                        null: false
#   t.string   :salt,                                    null: false
#   t.datetime :created_at
#   t.datetime :updated_at
#   t.integer  :questions_count,             default: 0
#   t.integer  :answers_count,               default: 0
#   t.integer  :comments_count,              default: 0
#   t.string   :screen_name
#   t.string   :avatar
#   t.string   :activation_state
#   t.string   :activation_token
#   t.datetime :activation_token_expires_at
#   t.boolean  :admin
# end
#
# add_index :users, [:activation_token], name: :index_users_on_activation_token, using: :btree
# add_index :users, [:email], name: :index_users_on_email, unique: true, using: :btree

class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :questions
  has_many :answers
  has_many :comments

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  validates :password, length: { minimum: 6 }, presence: true
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :email, uniqueness: true

  mount_uploader :avatar, AvatarUploader

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  def self.setup_oauth_user(provider, user)
    user.email = "#{user.screen_name.downcase}@#{provider}.com" unless user.email
    random_password = rand(36**8).to_s(36)
    user.password = random_password
    user.password_confirmation = random_password
    user
  end
end
