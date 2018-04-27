class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :text
      t.integer :author_id
      t.integer :votes
      t.integer :parent_id

      t.timestamps
    end
  end
end
