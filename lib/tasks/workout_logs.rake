namespace :workout_logs do
  desc "Import workout logs from json file"
  task import: :environment do

    f = File.read('db/workout_logs.json')
    workout_logs = JSON.parse f

    workout_logs["calendar_workout_logs"].each do |wl|
      WorkoutLog.create! wl
    end
  end
end
