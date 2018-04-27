class AddTipusToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :tipus, :string
  end
end
