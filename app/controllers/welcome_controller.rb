class WelcomeController < ApplicationController
  def index
    # Get the contact number and strip +1 country code
    @contact_phone_number = ENV["ROCKWORM_PHONE_NUMBER"][2..-1]
  end
end
