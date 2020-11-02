require "freeclimb"
require "google/cloud/speech"

class Recording
  def initialize(recording_id)
    @recording_id = recording_id
  end

  def transcribe
    Freeclimb.configure do |config|
      # Configure HTTP basic authorization: fc
      config.username = ENV["FC_ACCOUNT_ID"]
      config.password = ENV["FC_ACCOUNT_TOKEN"]
    end
    api_instance = Freeclimb::DefaultApi.new
    temp_file = api_instance.download_a_recording_file(@recording_id)

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
    text = ""
    results.first.alternatives.each do |alternatives|
      text = alternatives.transcript
    end

    temp_file.delete
    text
  rescue Exception => e
    puts "The controller had an error" + e.message
    puts "The controller had an error" + e.backtrace.inspect
  end
end
