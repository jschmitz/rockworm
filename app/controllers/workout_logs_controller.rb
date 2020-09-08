require "date"

class WorkoutLogsController < ApplicationController
  def index
    @workout_logs = WorkoutLog.all
  end
end
