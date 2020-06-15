class RemoveEvaluationFromRecords < ActiveRecord::Migration[5.2]
  def change
    remove_column :records, :evaluation, :string
  end
end
