class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid

      t.timestamps null: false
    end

    add_index :authorizations, [:provider, :uid]
  end
end
