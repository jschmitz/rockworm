class CreateWorkoutLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :workout_logs do |t|
      t.integer :intensity
      t.text :notes
      t.datetime :workout_date
      t.string :category
      t.text :pains
    end
  end
end
