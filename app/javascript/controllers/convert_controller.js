import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["inputImageFile", "inputImage", "outputImage"]

  async convert() {
    const csrfToken = document.head.querySelector('meta[name="csrf-token"]').getAttribute("content")
    await fetch(
      '/convert',
      {
        method: 'POST',
        headers: {
          "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify(
          {
            "type": "binarization_filter",
            "threshold": "80%",
            "input_image": {
              "type": "binary_image",
              "b64_image": btoa(await this.readFile())
            }
          }
        )
      }
    )
      .then(async (response) => {
        const json = await response.json()
        console.log(json)
        this.outputImageTarget.src = `data:image/png;base64,${json['result_image_b64']}`
      })
      .catch(error => {
        console.log(error)
      })
  }

  async readFile() {
    return new Promise(resolve => {
      if (this.inputImageFileTarget.files && this.inputImageFileTarget.files[0]) {
        const reader = new FileReader()
        reader.onload = function () {
          resolve(reader.result)
        }
        reader.readAsBinaryString(this.inputImageFileTarget.files[0])
      }
    })
  }

  previewUploaded() {
    if (this.inputImageFileTarget.files && this.inputImageFileTarget.files[0]) {
      const reader = new FileReader()
      const that = this
      reader.onload = function () {
        that.inputImageTarget.src = reader.result
      }
      reader.readAsDataURL(this.inputImageFileTarget.files[0])
    }
  }
}
