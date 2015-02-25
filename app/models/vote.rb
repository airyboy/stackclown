# create_table :votes, force: true do |t|
#   t.integer  :points
#   t.integer  :votable_id
#   t.string   :votable_type
#   t.datetime :created_at
#   t.datetime :updated_at
#   t.integer  :user_id
# end
#
# add_index :votes, [:user_id], name: :index_votes_on_user_id, using: :btree
# add_index :votes, [:votable_id, :votable_type], name: :index_votes_on_votable_id_and_votable_type, using: :btree

class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user, presence: true
  validates :points, presence: true
end
