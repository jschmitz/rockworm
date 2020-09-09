class AddRecordingIdToWorkout < ActiveRecord::Migration[6.0]
  def change
    add_column :workout_logs, :recording_id, :string
  end
end
