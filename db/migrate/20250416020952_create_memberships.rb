class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.text :reason
      t.datetime :joined_at

      t.timestamps
    end

    add_index :memberships, [ :user_id, :group_id ], unique: true
  end
end
