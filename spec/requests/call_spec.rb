require "rails_helper"

describe "Call" do
  before(:each) do
    ENV["ROCKWORM_PUBLIC_URL"] = "test_url"
  end

  it "FC inbound request responds with getDigits and Say Command" do
    inbound_call_request = FreeclimbMock.inbound

    post "/calls", params: inbound_call_request
    expect(response.body).to eq("[{\"GetDigits\":{\"actionUrl\":\"test_url/get_digits\",\"prompts\":[{\"Say\":{\"text\":\"Hello, Jake, tell me about your exercising. Did you get a work out today? Tell me how intense from zero to ten with 10 being the highest intensity.\"}}]}}]")
  end

  it "FC inbound request responds with getDigits and Say Command" do
    get_digits_request = FreeclimbMock.get_digits

    post "/get_digits", params: get_digits_request
    expect(response.body).to eq("[{\"Say\":{\"text\":\"Tell me more about your workout.\"}},{\"RecordUtterance\":{\"actionUrl\":\"test_url/record_utterance\"}}]")
  end

  it "saves the recording transcription and response with a getspeech action" do
    record_utterence_request = FreeclimbMock.record_utterance

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
    get_speech_request = FreeclimbMock.get_speech_success

    workout_log = instance_double(WorkoutLog)
    allow(WorkoutLog).to receive(:last).and_return(workout_log)
    allow(workout_log).to receive(:update!)
    expect(workout_log).to receive(:update!).with(category: "yoga")

    post "/category_select", params: get_speech_request
    expect(response.body).to eq("[{\"Say\":{\"text\":\"Selected category was yoga. Thank you have a great day, work out again\"}}]")
  end

  it "tells the communication service to play an error message to the caller" do
    get_speech_request = FreeclimbMock.get_speech_fail

    post "/category_select", params: get_speech_request
    expect(response.body).to eq("[{\"Say\":{\"text\":\"There was an error selecting a category. Go and enter it manually.\"}}]")
  end
end
