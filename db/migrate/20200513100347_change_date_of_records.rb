class ChangeDateOfRecords < ActiveRecord::Migration[5.2]
  def change
    remove_column :records, :day, :string
    add_column :records, :date, :date 
  end
end
