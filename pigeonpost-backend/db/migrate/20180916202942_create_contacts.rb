class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.integer :contact_id

      t.foreign_key :users, column: :user_id, :dependent => :delete
      t.foreign_key :users, column: :contact_id, :dependent => :delete

      t.index [:user_id, :contact_id], unique: true
    end
  end
end
