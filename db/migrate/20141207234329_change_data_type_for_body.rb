class ChangeDataTypeForBody < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.change :body, :text, limit:65535
    end

    change_table :answers do |t|
      t.change :body, :text, limit:65535
    end
  end
end
