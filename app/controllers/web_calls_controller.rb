class WebCallsController < ApplicationController
  def create
    say = Freeclimb::Say.new(text: "Hello, thank you for calling and thank you for visiting the website. Please leave me a message, with contact inofrmation, and I can get back to you.  Thank you!")
    rco = Freeclimb::RecordUtterance.new(action_url: "#{ENV["ROCKWORM_PUBLIC_URL"]}/record_utterance_web")
    percl_script = Freeclimb::PerclScript.new(commands: [say, rco])

    render json: Freeclimb::percl_to_json(percl_script)
  rescue => e
    puts "The controller had an error" + e
  end

  def record_utterance_web
    # Write the recording ID and Call ID to log for troubleshooting
    puts "Recording ID from website call is: #{params[:recordingId]}"
    puts "Call ID from website call is: #{params[:callId]}"

    message = Recording.new(params[:recordingId]).transcribe

    send_sms = Freeclimb::Sms.new(to: ENV["MY_PHONE_NUMBER"],
                                  from: ENV["ROCKWORM_PHONE_NUMBER"],
                                  text: message)

    #hangup = Freeclimb::Hangup.new
    percl_script = Freeclimb::PerclScript.new(commands: [send_sms])

    render json: Freeclimb::percl_to_json(percl_script)
  rescue Exception => e
    puts "The controller had an error" + e.message
    puts "The controller had an error" + e.backtrace.inspect
  end
end
