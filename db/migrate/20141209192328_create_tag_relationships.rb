class CreateTagRelationships < ActiveRecord::Migration
  def change
    create_table :tag_relationships do |t|
      t.integer :question_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
