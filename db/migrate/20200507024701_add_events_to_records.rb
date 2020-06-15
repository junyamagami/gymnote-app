class AddEventsToRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :fx, :string
    add_column :records, :ph, :string
    add_column :records, :sr, :string
    add_column :records, :vt, :string
    add_column :records, :pb, :string
    add_column :records, :hb, :string
    add_column :records, :ub, :string
    add_column :records, :bb, :string
  end
end
