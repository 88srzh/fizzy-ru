import { Controller } from "@hotwired/stimulus"
import { differenceInDays, secondsToDate } from "helpers/date_helpers"

const DEFAULT_LOCALE = "ru-RU"

const RUSSIAN_PLURALS = {
  year: ["год", "года", "лет"],
  month: ["месяц", "месяца", "месяцев"],
  week: ["неделя", "недели", "недель"],
  day: ["день", "дня", "дней"],
  hour: ["час", "часа", "часов"],
  minute: ["минута", "минуты", "минут"]
}

function pluralForm(quantity, forms) {
  const mod10 = quantity % 10
  const mod100 = quantity % 100
  if (mod10 === 1 && mod100 !== 11) return forms[0]
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return forms[1]
  return forms[2]
}

export default class extends Controller {
  static targets = [ "time", "date", "datetime", "shortdate", "ago", "indays", "daysago", "agoorweekday", "timeordate" ]
  static values = { refreshInterval: Number }
  static classes = [ "local-time-value"]

  #timer

  initialize() {
    this.timeFormatter = new Intl.DateTimeFormat(DEFAULT_LOCALE, { timeStyle: "short" })
    this.dateFormatter = new Intl.DateTimeFormat(DEFAULT_LOCALE, { dateStyle: "long" })
    this.shortdateFormatter = new Intl.DateTimeFormat(DEFAULT_LOCALE, { month: "short", day: "numeric" })
    this.datetimeFormatter = new Intl.DateTimeFormat(DEFAULT_LOCALE, { timeStyle: "short", dateStyle: "short" })
    this.agoFormatter = new AgoFormatter()
    this.daysagoFormatter = new DaysAgoFormatter()
    this.datewithweekdayFormatter = new Intl.DateTimeFormat(DEFAULT_LOCALE, { weekday: "long", month: "long", day: "numeric" })
    this.datewithweekdayFormatter = new Intl.DateTimeFormat(DEFAULT_LOCALE, { weekday: "long", month: "long", day: "numeric" })
    this.indaysFormatter = new InDaysFormatter()
    this.agoorweekdayFormatter = new DaysAgoOrWeekdayFormatter()
    this.timeordateFormatter = new TimeOrDateFormatter()
  }

  connect() {
    this.#timer = setInterval(() => this.#refreshRelativeTimes(), 30_000)
  }

  disconnect() {
    clearInterval(this.#timer)
  }

  refreshAll() {
    this.constructor.targets.forEach(targetName => {
      this.targets.findAll(targetName).forEach(target => {
        this.#formatTime(this[`${targetName}Formatter`], target)
      })
    })
  }

  refreshTarget(event) {
    const target = event.target;
    const targetName = target.dataset.localTimeTarget
    this.#formatTime(this[`${targetName}Formatter`], target)
  }

  timeTargetConnected(target) {
    this.#formatTime(this.timeFormatter, target)
  }

  dateTargetConnected(target) {
    this.#formatTime(this.dateFormatter, target)
  }

  datetimeTargetConnected(target) {
    this.#formatTime(this.datetimeFormatter, target)
  }

  shortdateTargetConnected(target) {
    this.#formatTime(this.shortdateFormatter, target)
  }

  agoTargetConnected(target) {
    this.#formatTime(this.agoFormatter, target)
  }

  indaysTargetConnected(target) {
    this.#formatTime(this.indaysFormatter, target)
  }

  daysagoTargetConnected(target) {
    this.#formatTime(this.daysagoFormatter, target)
  }

  agoorweekdayTargetConnected(target) {
    this.#formatTime(this.agoorweekdayFormatter, target)
  }

  timeordateTargetConnected(target) {
    this.#formatTime(this.timeordateFormatter, target)
  }

  #refreshRelativeTimes() {
    this.agoTargets.forEach(target => {
      this.#formatTime(this.agoFormatter, target)
    })
  }

  #formatTime(formatter, target) {
    const dt = secondsToDate(parseInt(target.getAttribute("datetime")))
    target.innerHTML = formatter.format(dt)
    target.title = this.datetimeFormatter.format(dt)
  }
}

class AgoFormatter {
  format(dt) {
    const now = new Date()
    const seconds = (now - dt) / 1000
    const minutes = seconds / 60
    const hours = minutes / 60
    const days = hours / 24
    const weeks = days / 7
    const months = days / (365 / 12)
    const years = days / 365

    if (years >= 1) return this.#pluralize("year", years)
    if (months >= 1) return this.#pluralize("month", months)
    if (weeks >= 1) return this.#pluralize("week", weeks)
    if (days >= 1) return this.#pluralize("day", days)
    if (hours >= 1) return this.#pluralize("hour", hours)
    if (minutes >= 1) return this.#pluralize("minute", minutes)

    return "Менее минуты назад"
  }

  #pluralize(word, quantity) {
    quantity = Math.floor(quantity)
    const forms = RUSSIAN_PLURALS[word]
    return `${quantity} ${pluralForm(quantity, forms)} назад`
  }
}

class DaysAgoFormatter {
  format(date) {
    const days = differenceInDays(date, new Date())

    if (days <= 0) return styleableValue("сегодня")
    if (days === 1) return styleableValue("вчера")
    return `${styleableValue(days)} ${pluralForm(days, RUSSIAN_PLURALS.day)} назад`
  }
}

class DaysAgoOrWeekdayFormatter {
  format(date) {
    const days = differenceInDays(date, new Date())

    if (days <= 1) {
      return new DaysAgoFormatter().format(date)
    } else {
      return new Intl.DateTimeFormat(DEFAULT_LOCALE, { weekday: "long", month: "long", day: "numeric" }).format(date)
    }
  }
}

class InDaysFormatter {
  format(date) {
    const days = differenceInDays(new Date(), date)

    if (days <= 0) return styleableValue("сегодня")
    if (days === 1) return styleableValue("завтра")
    return `через ${styleableValue(days)} ${pluralForm(days, RUSSIAN_PLURALS.day)}`
  }
}

class TimeOrDateFormatter {
  format(date) {
    const days = differenceInDays(date, new Date())

    if (days >= 1) {
      return new Intl.DateTimeFormat(DEFAULT_LOCALE, { month: "short", day: "numeric" }).format(date)
    } else {
      return new Intl.DateTimeFormat(DEFAULT_LOCALE, { timeStyle: "short" }).format(date)
    }
  }
}

function styleableValue(value) {
  return `<span class="local-time-value">${value}</span>`
}
