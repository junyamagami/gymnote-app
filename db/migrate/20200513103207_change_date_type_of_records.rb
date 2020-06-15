class ChangeDateTypeOfRecords < ActiveRecord::Migration[5.2]
  def change
    remove_column :records, :date, :date
    add_column :records, :date, :integer
  end
end
