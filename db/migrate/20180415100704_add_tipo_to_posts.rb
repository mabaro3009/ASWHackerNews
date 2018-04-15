class AddTipoToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :tipo, :string
  end
end
