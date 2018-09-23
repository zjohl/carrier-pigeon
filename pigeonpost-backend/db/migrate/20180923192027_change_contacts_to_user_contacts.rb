class ChangeContactsToUserContacts < ActiveRecord::Migration[5.2]
  def change
    rename_table :contacts, :user_contacts
  end
end
