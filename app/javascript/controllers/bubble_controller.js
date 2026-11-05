import { Controller } from "@hotwired/stimulus"
import { signedDifferenceInDays } from "helpers/date_helpers"

const REFRESH_INTERVAL = 3_600_000 // 1 hour (in milliseconds)

export default class extends Controller {
  static targets = [ "entropy", "stalled", "top", "center", "bottom" ]
  static values = { entropy: Object, stalled: Object }

  #timer

  connect() {
    this.#timer = setInterval(this.update.bind(this), REFRESH_INTERVAL)
    this.update()
  }

  disconnect() {
    clearInterval(this.#timer)
  }

  update() {
    if (this.#hasEntropy) {
      this.#showEntropy()
    } else if (this.#isStalled) {
      this.#showStalled()
    } else {
      this.#hide()
    }
  }

  get #hasEntropy() {
    return this.#entropyCleanupInDays < this.entropyValue.daysBeforeReminder
  }

  get #entropyCleanupInDays() {
    return signedDifferenceInDays(new Date(), new Date(this.entropyValue.closesAt))
  }

  #showEntropy() {
    this.#render({
      top: this.#entropyCleanupInDays < 1 ? this.entropyValue.action : `${this.entropyValue.action} через`,
      center: this.#entropyCleanupInDays < 1 ? "!" : this.#entropyCleanupInDays,
      bottom: this.#entropyCleanupInDays < 1 ? "Сегодня" : pluralDays(this.#entropyCleanupInDays),
    })
  }

  #render({ top, center, bottom }) {
    this.topTarget.innerHTML = top
    this.centerTarget.innerHTML = center
    this.bottomTarget.innerHTML = bottom

    this.#show()
  }

  // Keep in sync with Card::Stallable#stalled? in app/models/card/stallable.rb
  get #isStalled() {
    return this.stalledValue.lastActivitySpikeAt &&
      signedDifferenceInDays(new Date(this.stalledValue.lastActivitySpikeAt), new Date()) > this.stalledValue.stalledAfterDays &&
      signedDifferenceInDays(new Date(this.stalledValue.updatedAt), new Date()) > this.stalledValue.stalledAfterDays
  }

  #showStalled() {
    const days = signedDifferenceInDays(new Date(this.stalledValue.lastActivitySpikeAt), new Date())
    this.#render({
      top: "Застряла на",
      center: days,
      bottom: pluralDays(days)
    })
  }

  #hide() {
    this.element.toggleAttribute("hidden", true)
  }

  #show() {
    this.element.removeAttribute("hidden")
  }
}

function pluralDays(n) {
  const mod10 = n % 10
  const mod100 = n % 100
  if (mod10 === 1 && mod100 !== 11) return "день"
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return "дня"
  return "дней"
}
