class FreeclimbMock
  class << self
    def inbound
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
    end

    def record_utterance
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
    end

    def get_digits
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
    end

    def get_speech_success
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
    end

    def get_speech_fail
      {
        "accountid": "ac5a947e6afd4f9436917e6f212dc475c485f945c6",
        "callid": "ca9c02e079ad131f5c4ca0b059c499a6687e10b34c",
        "callstatus": "inprogress",
        "conferenceid": nil,
        "confidence": 96,
        "direction": "inbound",
        "from": "+13128541346",
        "parentcallid": nil,
        "privacymode": false,
        "queueid": nil,
        "reason": "fail",
        "recognitionresult": "yoga",
        "requesttype": "getspeech",
        "to": "+13123798952",
      }
    end
  end
end
