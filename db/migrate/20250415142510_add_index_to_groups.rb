class AddIndexToGroups < ActiveRecord::Migration[8.0]
  def change
    add_index :groups, :name, unique: true
  end
end
