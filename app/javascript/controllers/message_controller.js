import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["content", "result"]

  async send() {
    const csrfToken = document.head.querySelector(`meta[name="csrf-token"]`).getAttribute("content")
    const messageContent = this.Content
    let resultMessage = ""

    let response = await fetch('/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json;charset=utf-8',
        'X-CSRF-Token': csrfToken
      },
      body: `{"message": "${this.contentTarget.value}"}`,
    });

    if (response.ok) {
      resultMessage = "Thank you for the message!"
    } else {
      console.log("HTTP-Error: " + response.status);
      resultMessage = "There was an error sending your message."
    }

    this.resultTarget.innerHTML = resultMessage
  }
}
