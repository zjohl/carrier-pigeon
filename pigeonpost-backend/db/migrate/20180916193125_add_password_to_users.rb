class AddPasswordToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column(:users, :first_name, :string, required: true)
    add_column(:users, :last_name, :string, required: true)
    add_column(:users, :password, :string, required: true)

    change_column(:users, :name, :string, required: true)

    remove_column(:users, :name, :string)
  end
end
