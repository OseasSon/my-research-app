// Import and register all your controllers from the importmap under controllers/*
import { application } from "./application"
import ResetFormController from "./reset_form_controller"
import LoadingController from "./loading_controller"

application.register("reset-form", ResetFormController)
application.register("loading", LoadingController)
