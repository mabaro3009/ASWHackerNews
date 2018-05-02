class AddCommentIdToUpvote < ActiveRecord::Migration[5.1]
  def change
  add_column :upvotes, :comment_id, :integer
  end
end
