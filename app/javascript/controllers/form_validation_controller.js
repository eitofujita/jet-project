import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  invalid(event) {
    const field = event.target

    if (field.validity.valueMissing) {
      field.setCustomValidity("Заполните это поле.")
    } else if (field.validity.typeMismatch) {
      field.setCustomValidity("Введите корректное значение.")
    } else if (field.validity.tooShort) {
      field.setCustomValidity(`Введите не менее ${field.minLength} символов.`)
    } else if (field.validity.tooLong) {
      field.setCustomValidity(`Введите не более ${field.maxLength} символов.`)
    } else {
      field.setCustomValidity("Проверьте введённое значение.")
    }
  }

  clear(event) {
    event.target.setCustomValidity("")
  }
}
