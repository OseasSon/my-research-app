import { Application } from "@hotwired/stimulus"
import ContentLoader from 'stimulus-content-loader'

const application = Application.start()
application.register('content-loader', ContentLoader)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
