import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["inputImageSelector"]
  static values = {
    rejectGid: String
  }

  updateInputImageSelector() {
    const allGids = this.application.controllers.map(controller => controller['gidValue']).filter(gid => gid)
    console.log(this.rejectGidValue)
    const gidsWithoutMe = allGids.filter(gid => gid !== this.rejectGidValue)
    this.inputImageSelectorTarget.innerHTML = gidsWithoutMe.map((gid, i) => `<option name='${gid}' ${i == 0 ? 'selected' : ''}>${gid}</option>`).join('')
  }

  dispatchGidChanged() {
    this.element.dispatchEvent(new CustomEvent('gid-changed'), { bubbles: true })
  }

  connect() {
    this.updateInputImageSelector()
    this.element.dispatchEvent(new CustomEvent('gid-selector-connected', { bubbles: true }))
  }
}
