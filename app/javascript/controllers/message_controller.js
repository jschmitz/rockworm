import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["content", "result"]

  send() {
    this.resultTarget.innerHTML = `Under construction! ${this.contentTarget.value}`
  }
}
