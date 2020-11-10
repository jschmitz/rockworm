require "rails_helper"
require_relative "freeclimb_mock"
require "recording"

describe "Web Call" do
  before(:each) do
    ENV["ROCKWORM_PUBLIC_URL"] = "test_url"
  end

  it "FC inbound request responds say and record for website call" do
    inbound_call_request = FreeclimbMock.inbound

    post "/web_calls", params: inbound_call_request
    expect(response.body).to eq("[{\"Say\":{\"text\":\"Hello, thank you for calling and thank you for visiting the website. Please leave me a message, with contact inofrmation, and I can get back to you.  Thank you!\"}},{\"RecordUtterance\":{\"actionUrl\":\"test_url/record_utterance_web\"}}]")
  end

  it "FC inbound request responds say and record for website call" do
    ENV["MY_PHONE_NUMBER"] = "+17738675309"
    ENV["ROCKWORM_WEB_PHONE_NUMBER"] = "+13128675309"

    record_utterence_request = FreeclimbMock.record_utterance

    recording = instance_double(Recording)
    allow(Recording).to receive(:new).and_return(recording)
    allow(recording).to receive(:transcribe).and_return("This is my transcribed message")

    post "/record_utterance_web", params: record_utterence_request
    expect(response.body).to eq("[{\"Sms\":{\"to\":\"+17738675309\",\"from\":\"+13128675309\",\"text\":\"This is my transcribed message\"}}]")
  end
end
