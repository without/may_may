class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :id
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end
  end
end
