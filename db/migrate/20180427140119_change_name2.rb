class ChangeName2 < ActiveRecord::Migration[5.1]
  def change
	remove_column :comments, :author_id
	add_column :comments, :user_id, :integer
  end
end
