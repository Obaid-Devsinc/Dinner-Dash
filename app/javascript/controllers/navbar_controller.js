import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    window.addEventListener("cartCountUpdated", this.updateCartCount.bind(this));
  }

  updateCartCount(event) {
    const count = event.detail;
    let countEl = this.element.querySelector("#navbar-cart-count");

    if (countEl) {
      countEl.textContent = count;
      if (count === 0) countEl.remove();
    } else if (count > 0) {
      const cartLink = this.element.querySelector("#cart_count a");
      const span = document.createElement("span");
      span.id = "navbar-cart-count";
      span.className = "absolute -top-2 -right-4 bg-red-600 text-white text-xs font-semibold w-6 h-6 rounded-full flex items-center justify-center";
      span.textContent = count;
      cartLink.appendChild(span);
    }
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden_custom");
  }
}
