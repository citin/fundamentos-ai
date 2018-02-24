class CreateSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :searches do |t|
      t.string :text
      t.integer :hits, default: 1

      t.timestamps
    end
  end
end
