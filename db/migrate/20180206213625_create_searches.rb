class CreateSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :searches do |t|
      t.string :text
      t.integer :hits, default: 0
      t.datetime :last_search_at
      t.integer :ranking, default: 0

      t.timestamps
    end
  end
end
