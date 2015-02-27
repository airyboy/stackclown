class ChangeDefaultForUserRating < ActiveRecord::Migration
  def change
    change_column_default :users, :rating, 0
  end
end
