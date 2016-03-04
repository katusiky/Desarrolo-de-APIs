class CreateMyPolls < ActiveRecord::Migration
  def change
    create_table :my_polls do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :expires_at
      t.string :title, null: false
      t.text :description, null: false

      t.timestamps null: false
    end
  end
end
