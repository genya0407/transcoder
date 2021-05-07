import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'newGeneratorType', 'newGeneratorForm', 'convertForm'
  ]

  connect() {
    this.updateNewGeneratorLink()
  }

  submitForm() {
    this.convertFormTarget.dispatchEvent(new CustomEvent('submit', { bubbles: true }))
  }

  updateNewGeneratorLink() {
    this['newGeneratorFormTarget'].action = `/convert/create_generator?generator_type=${this['newGeneratorTypeTarget'].value}`
  }

  get generatorControllers() {
    this.generatorTypesValue.flatMap((type) => this.application.getControllerForElementAndIdentifier(this.element, type))
  }
}
