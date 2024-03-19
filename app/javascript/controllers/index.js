// Import and register all your controllers from the importmap under controllers/*

import { application } from "./application"

import ResetFormController from "./reset_form_controller"
application.register("reset-form", ResetFormController)

import SwitchFeatureController from "./switch_feature_controller"
application.register("switch-feature", SwitchFeatureController)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
