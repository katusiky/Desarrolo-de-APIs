class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :name
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps null: false
    end
  end
end
