class AddNcommentsToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :nComments, :integer
  end
end
