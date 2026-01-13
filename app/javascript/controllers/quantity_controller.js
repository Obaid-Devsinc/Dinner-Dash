// app/javascript/controllers/quantity_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden"]

  increment() {
    let value = parseInt(this.inputTarget.value)
    this.inputTarget.value = value + 1
    this.hiddenTarget.value = value + 1
  }

  decrement() {
    let value = parseInt(this.inputTarget.value)
    if (value > 1) {
      this.inputTarget.value = value - 1
      this.hiddenTarget.value = value - 1
    }
  }
}
