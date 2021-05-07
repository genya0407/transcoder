import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'convertForm'
  ]

  submitForm() {
    this.convertFormTarget.dispatchEvent(new CustomEvent('submit'))
  }

  get generatorControllers() {
    this.generatorTypesValue.flatMap((type) => this.application.getControllerForElementAndIdentifier(this.element, type))
  }
}
