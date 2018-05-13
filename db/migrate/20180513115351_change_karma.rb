class ChangeKarma < ActiveRecord::Migration[5.1]
  def change
	change_column :users, :karma, :integer, default: 0
  end
end
