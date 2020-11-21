require "freeclimb"

class MessageController < ApplicationController
  def create
    puts "Show some flash!"
    flash.now[:info] = "Thank you for the message!"
    flash[:info] = "Thank you for the message!"
    flash[:error] = "Thank you for the message!"
    flash[:alert] = "Thank you for the message!"
    @my_message = "messageing thas asdf"

    render :create
    #if Message.send("from", "to", "text")
    #  flash.now[:info] = "Thank you for the message!"
    #else
    #  flash.now[:error] = "Hmmm there was a problem sending that needs attention... can you check back later on?"
    #end
  end
end

class Message
  def self.send(from, to, text)
    true
    #Freeclimb.configure do |config|
    #  # Configure HTTP basic authorization: fc
    #  config.username = ENV["FC_ACCOUNT_ID"]
    #  config.password = ENV["FC_ACCOUNT_TOKEN"]
    #end

    #api_instance = Freeclimb::DefaultApi.new
    #message_request = Freeclimb::MessageRequest.new(
    #  from: ENV["ROCKWORM_PHONE_NUMBER"],
    #  to: ENV["MY_PHONE_NUMBER"],
    #  text: params["message"],
    #)

    #begin
    #  api_instance.send_an_sms_message(message_request)
    #  true
    #rescue Freeclimb::ApiError => e
    #  puts "Exception when calling DefaultApi->send_an_sms_message: #{e}"
    #  false
    #end
  end
end
