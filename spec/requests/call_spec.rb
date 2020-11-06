require "rails_helper"

RSpec.describe "Call" do
  it "FC inbound request responds with getDigits and Say Command" do
    inbound_call_request =
      {
        "accountId": "AC5a947e6afd4f9436917e6f212dc475c485f945c6",
        "callId": "CA740eca0b82c43dcc15ee07039261043ecb0ceb29",
        "callStatus": "ringing",
        "conferenceId": nil,
        "direction": "inbound",
        "from": "+17733504513",
        "parentCallId": nil,
        "queueId": nil,
        "requestType": "inboundCall",
        "to": "+13122817478",
      }
    ENV["ROCKWORM_PUBLIC_URL"] = "test_url"

    post "/calls", params: inbound_call_request
    expect(response.body).to eq("[{\"GetDigits\":{\"actionUrl\":\"test_url/get_digits\",\"prompts\":[{\"Say\":{\"text\":\"Hello, Jake, tell me about your exercising. Did you get a work out today? Tell me how intense from zero to ten with 10 being the highest intensity.\"}}]}}]")
  end

  it "FC inbound request responds with getDigits and Say Command" do
    get_digits_request =
      {
        "accountId": "AC5a947e6afd4f9436917e6f212dc475c485f945c6",
        "callId": "CA680482346fd7bcef7343dd39e019596fc1cee960",
        "callStatus": "inProgress",
        "conferenceId": nil,
        "digits": "1",
        "direction": "inbound",
        "from": "+17733504513",
        "parentCallId": nil,
        "privacyMode": false,
        "queueId": nil,
        "reason": "timeout",
        "requestType": "getDigits",
        "to": "+13123798952",
      }

    ENV["ROCKWORM_PUBLIC_URL"] = "test_url"

    post "/get_digits", params: get_digits_request
    expect(response.body).to eq("[{\"Say\":{\"text\":\"Tell me more about your workout.\"}},{\"RecordUtterance\":{\"actionUrl\":\"test_url/record_utterance\"}}]")
  end

  it "saves the recording transcription and response with a getspeech action" do
    record_utterence_request =
      {
        "accountId": "AC5a947e6afd4f9436917e6f212dc475c485f945c6",
        "callId": "CAb5b20f6cfcc83f162411b3f0f4f2b1398423e2ea",
        "callStatus": "inProgress",
        "conferenceId": nil,
        "direction": "inbound",
        "from": "+17733504513",
        "parentCallId": nil,
        "queueId": nil,
        "recordingDurationSec": 1,
        "recordingFormat": "audio/wav",
        "recordingId": "RE87ba0052e8ea3712feebb613f025720dc75c4b86",
        "recordingSize": 684,
        "recordingUrl": "/Accounts/AC5a947e6afd4f9436917e6f212dc475c485f945c6/Recordings/RE87ba0052e8ea3712feebb613f025720dc75c4b86/Download",
        "requestType": "record",
        "termReason": "timeout",
        "to": "+13123798952",
      }

    ENV["ROCKWORM_PUBLIC_URL"] = "test_url"

    workout_log = instance_double(WorkoutLog)
    allow(WorkoutLog).to receive(:last).and_return(workout_log)
    allow(workout_log).to receive(:update!)
    expect(workout_log).to receive(:update!).with(notes: "This is my transcribed message")

    recording = instance_double(Recording)
    allow(Recording).to receive(:new).and_return(recording)
    allow(recording).to receive(:transcribe).and_return("This is my transcribed message")

    post "/record_utterance", params: record_utterence_request
    expect(response.body).to eq("[{\"Say\":{\"text\":\"What category of workout did you get in?\"}},{\"GetSpeech\":{\"actionUrl\":\"test_url/category_select\",\"grammarType\":\"URL\",\"grammarFile\":\"test_url/grammar_file\"}}]")
  end

  it "saves the category transcription and response with a getspeech action" do
    get_speech_request =
      {
        "accountId": "AC5a947e6afd4f9436917e6f212dc475c485f945c6",
        "callId": "CA9c02e079ad131f5c4ca0b059c499a6687e10b34c",
        "callStatus": "inProgress",
        "conferenceId": nil,
        "confidence": 96,
        "direction": "inbound",
        "from": "+13128541346",
        "parentCallId": nil,
        "privacyMode": false,
        "queueId": nil,
        "reason": "recognition",
        "recognitionResult": "yoga",
        "requestType": "getSpeech",
        "to": "+13123798952",
      }

    ENV["ROCKWORM_PUBLIC_URL"] = "test_url"

    workout_log = instance_double(WorkoutLog)
    allow(WorkoutLog).to receive(:last).and_return(workout_log)
    allow(workout_log).to receive(:update!)
    expect(workout_log).to receive(:update!).with(category: "yoga")

    post "/category_select", params: get_speech_request
    expect(response.body).to eq("[{\"Say\":{\"text\":\"Selected category was yoga. Thank you have a great day, work out again\"}}]")
  end

  it "tells the communication service to play an error message to the caller" do
    get_speech_request =
      {
        "accountId": "AC5a947e6afd4f9436917e6f212dc475c485f945c6",
        "callId": "CA9c02e079ad131f5c4ca0b059c499a6687e10b34c",
        "callStatus": "inProgress",
        "conferenceId": nil,
        "confidence": 96,
        "direction": "inbound",
        "from": "+13128541346",
        "parentCallId": nil,
        "privacyMode": false,
        "queueId": nil,
        "reason": "fail",
        "recognitionResult": "yoga",
        "requestType": "getSpeech",
        "to": "+13123798952",
      }

    ENV["ROCKWORM_PUBLIC_URL"] = "test_url"

    post "/category_select", params: get_speech_request
    expect(response.body).to eq("[{\"Say\":{\"text\":\"There was an error selecting a category. Go and enter it manually.\"}}]")
  end
end
