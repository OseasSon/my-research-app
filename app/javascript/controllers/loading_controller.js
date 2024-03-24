import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = [ "spinner", "submitButton" ]

  show() {
    this.spinnerTarget.style.display = 'block'; // Show the loading spinner
    this.submitButtonTarget.disabled = true; // Disable the submit button
    this.submitButtonTarget.style.backgroundColor = '#e5e7eb'; // Change the submit button color
  }
}
