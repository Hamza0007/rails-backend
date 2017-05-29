class AddDefaultValueInUsers < ActiveRecord::Migration
  def up
    change_column :users, :role, :string, default: 'player'
    change_column :users, :status, :string, default: 'enabled'
  end

  def down
    change_column :users, :role, :string, default: nil
    change_column :users, :status, :string, default: nil
  end
end
