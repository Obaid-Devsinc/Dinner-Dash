import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"]

  connect() {
    if (window.innerWidth < 1024) {
      this.hide()
    }
  }

  toggle() {
    this.sidebarTarget.classList.toggle("translate-x-0")
    this.sidebarTarget.classList.toggle("-translate-x-full")
  }

  show() {
    this.sidebarTarget.classList.remove("-translate-x-full")
    this.sidebarTarget.classList.add("translate-x-0")
  }

  hide() {
    this.sidebarTarget.classList.remove("translate-x-0")
    this.sidebarTarget.classList.add("-translate-x-full")
  }
}
