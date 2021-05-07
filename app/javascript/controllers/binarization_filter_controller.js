import { Controller } from "stimulus"

export default class extends Controller {
  static values = {
    gid: String
  }

  submit() {
    this.element.dispatchEvent(new CustomEvent('submit-converter-form', { bubbles: true }))
  }

  remove() {
    this.element.parentNode.removeChild(this.element)
  }
}
