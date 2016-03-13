class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :commentable_id
      t.string :commentable_type
      t.text :body

      t.timestamps null: false
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
