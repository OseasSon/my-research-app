import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="switch-feature"
export default class extends Controller {
  static targets = [ "button", "content" ]

  connect() {
    this.showContent(1)
  }

  switch(event) {
    const index = this.buttonTargets.indexOf(event.currentTarget)
    this.showContent(index)
  }

  showContent(index) {
    this.buttonTargets.forEach((btn, i) => {
      btn.classList.toggle('active', i === index)
    })

    this.contentTargets.forEach((content, i) => {
      content.style.display = i === index ? 'block' : 'none'
    })
  }
}
