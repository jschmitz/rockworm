require "rails_helper"

RSpec.describe "Web Call" do
  it "FC inbound request responds say and record for website call" do
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

    post "/web_calls", params: inbound_call_request
    expect(response.body).to eq("[{\"Say\":{\"text\":\"Hello, thank you for calling and thank you for visiting the website. Please leave me a message, with contact inofrmation, and I can get back to you.  Thank you!\"}},{\"RecordUtterance\":{\"actionUrl\":\"test_url/record_utterance_web\"}}]")
  end

  it "FC inbound request responds say and record for website call" do
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
    recording = instance_double(Recording)
    allow(Recording).to receive(:new).and_return(recording)
    allow(recording).to receive(:transcribe).and_return("This is my transcribed message")

    post "/record_utterance_web", params: record_utterence_request
    expect(response.body).to eq("[{\"Sms\":{\"to\":\"+17733504513\",\"from\":\"+13123798952\",\"text\":\"This is my transcribed message\"}}]")
  end
end
