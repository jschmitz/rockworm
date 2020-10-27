require "freeclimb"

class MessageController < ApplicationController
  def create
    Freeclimb.configure do |config|
      # Configure HTTP basic authorization: fc
      config.username = ENV["FC_ACCOUNT_ID"]
      config.password = ENV["FC_ACCOUNT_TOKEN"]
    end

    api_instance = Freeclimb::DefaultApi.new
    message_request = Freeclimb::MessageRequest.new(
      from: ENV["ROCKWORM_PHONE_NUMBER"],
      to: ENV["MY_PHONE_NUMBER"],
      text: params["message"],
    )

    begin
      result = api_instance.send_an_sms_message(message_request)
      p result
    rescue Freeclimb::ApiError => e
      puts "Exception when calling DefaultApi->send_an_sms_message: #{e}"
    end
  end
end
