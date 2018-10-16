class ChangeStatusToEnum < ActiveRecord::Migration[5.2]
  def change
  	remove_column(:deliveries, :status, :string)
  	add_column(:deliveries, :status, :integer, required: true, null: false, default: 0)
  end
end
