class AddColumnsToGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :groups, :max_members, :integer, default: 0
    add_column :groups, :memberships_count, :integer, default: 0
    add_column :groups, :status, :integer, default: 0
  end
end
