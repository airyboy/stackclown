# create_table :authentications, force: true do |t|
#   t.integer  :user_id,    null: false
#   t.string   :provider,   null: false
#   t.string   :uid,        null: false
#   t.datetime :created_at
#   t.datetime :updated_at
# end
#
# add_index :authentications, [:user_id, :provider], name: :index_authentications_on_user_id_and_provider, using: :btree

class Authentication < ActiveRecord::Base
  belongs_to :user
end
