require "date"

class WorkoutLogsController < ApplicationController
  def index
    @workout_logs = WorkoutLog.all

    calendar_info = Hash.new

    calendar_workout_logs = []
    @workout_logs.each do |wl|
      h = Hash.new
      h["workout_date"] = wl.workout_date if wl.workout_date
      h["day_of_week"] = wl.workout_date.strftime("%A") if wl.workout_date
      h["week_of_year"] = wl.workout_date.strftime("%U").to_i if wl.workout_date
      h["notes"] = wl.notes
      h["category"] = wl.category
      h["intensity"] = wl.intensity

      calendar_workout_logs << h
    end

    weeks_of_year = calendar_workout_logs.filter_map { |w| w["workout_date"].strftime("%U") if w["workout_date"] }
    calendar_info["week_of_year_min"] = 0
    calendar_info["week_of_year_max"] = Date.today.strftime("%U").to_i
    calendar_info["calendar_workout_logs"] = calendar_workout_logs

    respond_to do |format|
      format.json { render json: calendar_info }
      format.html
    end
  end
end
