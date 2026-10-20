class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :weight
      t.references :category, null: false, foreign_key: true
      t.references :frequency, null: false, foreign_key: true

      t.timestamps
    end
  end
end
