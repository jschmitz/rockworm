require "freeclimb"

class MessageController < ApplicationController
  def create
    if Message.send(params["message"])
      render plain: "Success"
    else
      render plain: "Fail"
    end
  end
end

class Message
  def self.send(text)
    Freeclimb.configure do |config|
      # Configure HTTP basic authorization: fc
      config.username = ENV["FC_ACCOUNT_ID"]
      config.password = ENV["FC_ACCOUNT_TOKEN"]
    end

    api_instance = Freeclimb::DefaultApi.new
    message_request = Freeclimb::MessageRequest.new(
      from: ENV["ROCKWORM_PHONE_NUMBER"],
      to: ENV["MY_PHONE_NUMBER"],
      text: text,
    )

    begin
      api_instance.send_an_sms_message(message_request)
      true
    rescue Freeclimb::ApiError => e
      puts "Exception when calling DefaultApi->send_an_sms_message: #{e}"
      false
    end
  end
end
