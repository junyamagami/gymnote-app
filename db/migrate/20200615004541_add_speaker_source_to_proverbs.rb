class AddSpeakerSourceToProverbs < ActiveRecord::Migration[5.2]
  def change
    add_column :proverbs, :speaker, :string
    add_column :proverbs, :source, :string
    add_column :proverbs, :url, :string
  end
end
