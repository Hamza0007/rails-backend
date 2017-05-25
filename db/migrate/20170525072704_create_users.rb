class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :age
      t.decimal :average
      t.string :role
      t.string :status
      t.integer :matches
      t.references :team, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
