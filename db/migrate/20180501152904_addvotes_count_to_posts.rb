class AddvotesCountToPosts < ActiveRecord::Migration[5.1]
  def change
  add_column :posts, :upvotes_count, :integer
  end
end
