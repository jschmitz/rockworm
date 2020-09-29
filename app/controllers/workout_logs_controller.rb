require "date"

class WorkoutLogsController < ApplicationController
  def index
    @workout_logs = WorkoutLog.all

    calendar_workout_logs = []
    @workout_logs.each do |wl|
      h = Hash.new
      h["day_of_week"] = wl.workout_date.strftime("%A") if wl.workout_date
      h["week_of_year"] = wl.workout_date.strftime("%U") if wl.workout_date
      h["notes"] = wl.notes
      h["category"] = wl.category
      h["intensity"] = wl.intensity

      calendar_workout_logs << h
    end

    respond_to do |format|
      format.json { render json: calendar_workout_logs }
      format.html
    end
  end
end
