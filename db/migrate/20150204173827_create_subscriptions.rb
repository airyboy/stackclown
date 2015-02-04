class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :question
      t.references :user

      t.timestamps
    end
  end
end
