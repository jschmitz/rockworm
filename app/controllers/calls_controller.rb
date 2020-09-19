require "freeclimb"
require "google/cloud/speech"
require "nokogiri"

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
    speech_to_text(params[:recordingId])

    say = Freeclimb::Say.new(text: "What category of workout did you get in?")

    puts "#{ENV["ROCKWORM_PUBLIC_URL"]}/grammar_file"
    puts "#{ENV["ROCKWORM_PUBLIC_URL"]}"

    getSpeech = Freeclimb::GetSpeech.new(action_url: "#{ENV["ROCKWORM_PUBLIC_URL"]}/category_select", grammar_file: "#{ENV["ROCKWORM_PUBLIC_URL"]}/grammar_file", grammar_type: "URL")

    percl_script = Freeclimb::PerclScript.new(commands: [say, getSpeech])

    render json: Freeclimb::percl_to_json(percl_script)
  rescue Exception => e
    puts "The controller had an error" + e.message
    puts "The controller had an error" + e.backtrace.inspect
  end

  #  GetSpeech webhook
  #  {
  #    "accountId": "AC5a947e6afd4f9436917e6f212dc475c485f945c6",
  #    "callId": "CA9c02e079ad131f5c4ca0b059c499a6687e10b34c",
  #    "callStatus": "inProgress",
  #    "conferenceId": null,
  #    "confidence": 96,
  #    "direction": "inbound",
  #    "from": "+13128541346",
  #    "parentCallId": null,
  #    "privacyMode": false,
  #    "queueId": null,
  #    "reason": "recognition",
  #    "recognitionResult": "yoga",
  #    "requestType": "getSpeech",
  #    "to": "+13123798952"
  # }
  def category_select
    if (params["reason"] == "recognition")
      category = params["recognitionResult"]
      say = Freeclimb::Say.new(text: "Selected category was #{category}. Thank you have a great day, work out again")
      wl = WorkoutLog.last
      wl.update!(category: category)
    else
      say = Freeclimb::Say.new(text: "There was an error selecting a category. Go and enter it manually.")
    end

    percl_script = Freeclimb::PerclScript.new(commands: [say])

    render json: Freeclimb::percl_to_json(percl_script)
  rescue Exception => e
    puts "The controller had an error" + e.message
    puts "The controller had an error" + e.backtrace.inspect
  end

  def grammar_file
    xml_str = <<EOF
<grammar xmlns:sapi="http://schemas.microsoft.com/Speech/2002/06/SRGSExtensions" xml:lang="EN-US" tag-format="semantics-ms/1.0" version="1.0" root="workout_category" mode="voice" xmlns="http://www.w3.org/2001/06/grammar" sapi:alphabet="x-microsoft-ups">
  <rule id="workout_category" scope="public">
    <one-of>
      <item><tag>$._value = "yoga"</tag>yoga</item>
      <item><tag>$._value = "boxing"</tag>boxing</item>
      <item><tag>$._value = "functional"</tag>functional</item>
      <item><tag>$._value = "cardio"</tag>cardio</item>
      <item><tag>$._value = "mobility"</tag>mobility</item>
    </one-of>
  </rule>
</grammar>
EOF

    doc = Nokogiri::XML(xml_str)
    send_data doc, filename: "workout_categories.xml"
  end

  def speech_to_text(recording_id)
    Freeclimb.configure do |config|
      # Configure HTTP basic authorization: fc
      config.username = ENV["FC_ACCOUNT_ID"]
      config.password = ENV["FC_ACCOUNT_TOKEN"]
    end
    api_instance = Freeclimb::DefaultApi.new
    temp_file = api_instance.download_a_recording_file(recording_id)

    #Instantiates a client
    speech = Google::Cloud::Speech.speech

    # The raw audio
    audio_file = File.binread temp_file.path

    # The audio file's encoding and sample rate
    config = { encoding: :MULAW,
               sample_rate_hertz: 8_000,
               language_code: "en-US" }
    audio = { content: audio_file }

    # Detects speech in the audio file
    response = speech.recognize config: config, audio: audio
    results = response.results

    # Get first result because we only processed a single audio file
    # Each result represents a consecutive portion of the audio
    results.first.alternatives.each do |alternatives|
      wl = WorkoutLog.last
      wl.update!(notes: alternatives.transcript)
    end

    temp_file.delete
  rescue Exception => e
    puts "The controller had an error" + e.message
    puts "The controller had an error" + e.backtrace.inspect
  end
end
