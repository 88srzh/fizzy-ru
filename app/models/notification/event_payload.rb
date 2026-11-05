class Notification::EventPayload < Notification::DefaultPayload
  include ExcerptHelper

  def title
    case event.action
    when "comment_created"
      "RE: #{card_title}"
    else
      card_title
    end
  end

  def body
    case event.action
    when "comment_created"
      format_excerpt(event.eventable.body, length: 200)
    when "card_assigned"
      "Назначено вам пользователем #{event.creator.name}"
    when "card_published"
      "Добавлено пользователем #{event.creator.name}"
    when "card_closed"
      card.closure ? "Перемещено в «Готово» пользователем #{event.creator.name}" : "Закрыто пользователем #{event.creator.name}"
    when "card_reopened"
      "Вновь открыто пользователем #{event.creator.name}"
    when "card_triaged"
      if column_name.present?
        "Перемещено в «#{column_name}» пользователем #{event.creator.name}"
      else
        "Перемещено пользователем #{event.creator.name}"
      end
    when "card_sent_back_to_triage"
      "Возвращено в «Возможно?» пользователем #{event.creator.name}"
    when "card_board_changed", "card_collection_changed"
      if new_location_name.present?
        "Перемещено в «#{new_location_name}» пользователем #{event.creator.name}"
      else
        "Перемещено пользователем #{event.creator.name}"
      end
    when "card_title_changed"
      if new_title.present?
        "Переименовано в «#{new_title}» пользователем #{event.creator.name}"
      else
        "Переименовано пользователем #{event.creator.name}"
      end
    when "card_postponed"
      "Перемещено в «Не сейчас» пользователем #{event.creator.name}"
    when "card_auto_postponed"
      "Перемещено в «Не сейчас» из-за бездействия"
    else
      "Обновлено пользователем #{event.creator.name}"
    end
  end

  def url
    case event.action
    when "comment_created"
      card_url_with_comment_anchor(event.eventable)
    else
      card_url(card)
    end
  end

  def category
    case event.action
    when "card_assigned" then "assignment"
    when "comment_created" then "comment"
    else "card"
    end
  end

  def high_priority?
    event.action.card_assigned?
  end

  private
    def event
      notification.source
    end

    def card_title
      card.title.presence || "Карточка #{card.number}"
    end

    def event_particulars
      event.particulars.dig("particulars") || {}
    end

    def column_name
      event_particulars["column"]
    end

    def new_location_name
      event_particulars["new_board"] || event_particulars["new_collection"]
    end

    def new_title
      event_particulars["new_title"]
    end

    def card_url_with_comment_anchor(comment)
      Rails.application.routes.url_helpers.card_url(
        comment.card,
        anchor: ActionView::RecordIdentifier.dom_id(comment),
        **url_options
      )
    end
end
