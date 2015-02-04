class CreateDailyDigests < ActiveRecord::Migration
  def change
    create_table :daily_digests do |t|

      t.timestamps
    end
  end
end
