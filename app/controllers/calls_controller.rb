require "freeclimb"

class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Exmaple inbound webhook
  # TODO move to mock and test
  #  {
  #    "accountId": "AC5a947e6afd4f9436917e6f212dc475c485f945c6",
  #    "callId": "CA2865a1299ec04d6530bf9c6887614cd8d2afda51",
  #    "callStatus": "inProgress",
  #    "conferenceId": null,
  #    "dialCallStatus": "inProgress",
  #    "direction": "outboundAPI",
  #    "from": "+13123798952",
  #    "parentCallId": null,
  #    "queueId": null,
  #    "requestType": "outDialApiConnect",
  #    "to": "+13128541346"
  #  }
  def create
    say = Freeclimb::Say.new(text: "Hello, Jake, tell me about your exercising. Did you get a work out today? One for Yes, Two for No")
    get_digits = Freeclimb::GetDigits.new(action_url: "#{ENV["ROCKWORM_PUBLIC_URL"]}/get_digits", prompts: [say])
    percl_script = Freeclimb::PerclScript.new(commands: [get_digits])

    render json: Freeclimb::percl_to_json(percl_script)
  rescue => e
    puts "The controller had an error" + e
  end

  # Example getDigits webhook
  # TODO move to mock and test
  #  {
  #    "accountId": "AC5a947e6afd4f9436917e6f212dc475c485f945c6",
  #    "callId": "CA680482346fd7bcef7343dd39e019596fc1cee960",
  #    "callStatus": "inProgress",
  #    "conferenceId": null,
  #    "digits": "1",
  #    "direction": "inbound",
  #    "from": "+17733504513",
  #    "parentCallId": null,
  #    "privacyMode": false,
  #    "queueId": null,
  #    "reason": "timeout",
  #    "requestType": "getDigits",
  #    "to": "+13123798952"
  #  }
  def get_digits
    say = Freeclimb::Say.new(text: "Tell me more about your workout.")
    rc = Freeclimb::RecordUtterance.new(action_url: "#{ENV["ROCKWORM_PUBLIC_URL"]}/record_utterance")
    percl_script = Freeclimb::PerclScript.new(commands: [say, rc])

    wl = WorkoutLog.create!(workout_date: Time.now, intensity: params["digits"])

    render json: Freeclimb::percl_to_json(percl_script)
  rescue Exception => e
    puts "The controller had an error" + e.message
    puts "The controller had an error" + e.backtrace.inspect
  end

  # # Example record webhook
  # # TODO move to mock and test
  # {
  #   "accountId": "AC5a947e6afd4f9436917e6f212dc475c485f945c6",
  #   "callId": "CAb5b20f6cfcc83f162411b3f0f4f2b1398423e2ea",
  #   "callStatus": "inProgress",
  #   "conferenceId": null,
  #   "direction": "inbound",
  #   "from": "+17733504513",
  #   "parentCallId": null,
  #   "queueId": null,
  #   "recordingDurationSec": 1,
  #   "recordingFormat": "audio/wav",
  #   "recordingId": "RE87ba0052e8ea3712feebb613f025720dc75c4b86",
  #   "recordingSize": 684,
  #   "recordingUrl": "/Accounts/AC5a947e6afd4f9436917e6f212dc475c485f945c6/Recordings/RE87ba0052e8ea3712feebb613f025720dc75c4b86/Download",
  #   "requestType": "record",
  #   "termReason": "timeout",
  #   "to": "+13123798952"
  # }
  def record_utterance
    # TODO - This will work for one user only. Must change for multi users.
    wl = WorkoutLog.last
    wl.update!(recording_id: params[:recordingId])

    say = Freeclimb::Say.new(text: "Thank you and have a great day Jake")
    percl_script = Freeclimb::PerclScript.new(commands: [say])

    render json: Freeclimb::percl_to_json(percl_script)
  rescue Exception => e
    puts "The controller had an error" + e.message
    puts "The controller had an error" + e.backtrace.inspect
  end
end
