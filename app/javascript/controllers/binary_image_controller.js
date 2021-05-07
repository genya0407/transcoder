import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["type", "inputImageFile", "inputImage", "b64Image"]
  static values = {
    gid: String
  }

  async readFile() {
    return new Promise(resolve => {
      if (this.inputImageFileTarget.files && this.inputImageFileTarget.files[0]) {
        const reader = new FileReader()
        reader.onload = () => {
          resolve(reader.result)
        }
        reader.readAsBinaryString(this.inputImageFileTarget.files[0])
      }
    })
  }

  submitForm() {
    if (this.inputImageFileTarget.files && this.inputImageFileTarget.files[0]) {
      const reader = new FileReader()
      reader.onload = () => {
        this.b64ImageTarget.value = reader.result.replace(new RegExp('data:.+;base64,'), '')
        this.dispatchFormSubmitEvent()
      }
      reader.readAsDataURL(this.inputImageFileTarget.files[0])
    }
  }

  dispatchFormSubmitEvent() {
    this.element.dispatchEvent(new CustomEvent('submit-converter-form', { bubbles: true }))
  }

  remove() {
    this.element.parentNode.removeChild(this.element)
  }
}
