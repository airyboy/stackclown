class AddUserRefToVotes < ActiveRecord::Migration
  def change
    add_reference :votes, :user, index: true
    add_index :votes, [:votable_id, :votable_type], unique: true
  end
end
