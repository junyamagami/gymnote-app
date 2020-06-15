class AddEvaluationToRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :evaluation, :string
  end
end
