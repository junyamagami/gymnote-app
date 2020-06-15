class ChageDateType3OfRecords < ActiveRecord::Migration[5.2]
  def change
    remove_column :records, :date, :string
    add_column :records, :date, :integer
  end
end
