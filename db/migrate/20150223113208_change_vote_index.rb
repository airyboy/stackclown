class ChangeVoteIndex < ActiveRecord::Migration
  def change
    remove_index :votes, [:votable_id, :votable_type]
    add_index :votes, [:votable_id, :votable_type]
  end
end
