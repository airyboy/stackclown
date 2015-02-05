# create_table :subscriptions, force: true do |t|
#   t.integer  :question_id
#   t.integer  :user_id
#   t.datetime :created_at
#   t.datetime :updated_at
# end
#
# add_index :subscriptions, [:user_id, :question_id], name: :index_subscriptions_on_user_id_and_question_id, unique: true, using: :btree

class Subscription < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question, presence: true
  validates :user, presence: true
end
