require "freeclimb"
require "recording"
require "nokogiri"

class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    say = Freeclimb::Say.new(text: "Hello, Jake, tell me about your exercising. Did you get a work out today? Tell me how intense from zero to ten with 10 being the highest intensity.")
    get_digits = Freeclimb::GetDigits.new(action_url: "#{ENV["ROCKWORM_PUBLIC_URL"]}/get_digits", prompts: [say])
    percl_script = Freeclimb::PerclScript.new(commands: [get_digits])

    render json: Freeclimb::percl_to_json(percl_script)
  rescue => e
    puts "The controller had an error" + e
  end

  def get_digits
    WorkoutLog.create! intensity: params[:digits], workout_date: Time.now

    say = Freeclimb::Say.new(text: "Tell me more about your workout.")
    rc = Freeclimb::RecordUtterance.new(action_url: "#{ENV["ROCKWORM_PUBLIC_URL"]}/record_utterance")
    percl_script = Freeclimb::PerclScript.new(commands: [say, rc])

    render json: Freeclimb::percl_to_json(percl_script)
  rescue Exception => e
    puts "The controller had an error" + e.message
    puts "The controller had an error" + e.backtrace.inspect
  end

  def record_utterance
    # TODO - This will work for one user only. Must change for multi users.
    wl = WorkoutLog.last

    # update one at a time to ensure the recording id is persisted if the transcription fails
    wl.update!(recording_id: params[:recordingId])
    wl.update!(notes: Recording.new(params[:recordingId]).transcribe)

    say = Freeclimb::Say.new(text: "What category of workout did you get in?")

    getSpeech = Freeclimb::GetSpeech.new(action_url: "#{ENV["ROCKWORM_PUBLIC_URL"]}/category_select", grammar_file: "#{ENV["ROCKWORM_PUBLIC_URL"]}/grammar_file", grammar_type: "URL")

    percl_script = Freeclimb::PerclScript.new(commands: [say, getSpeech])

    render json: Freeclimb::percl_to_json(percl_script)
  rescue Exception => e
    puts "The controller had an error" + e.message
    puts "The controller had an error" + e.backtrace.inspect
  end

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
      <item><tag>$._value = "other"</tag>mobility</item>
    </one-of>
  </rule>
</grammar>
EOF

    doc = Nokogiri::XML(xml_str)
    send_data doc, filename: "workout_categories.xml"
  end
end
