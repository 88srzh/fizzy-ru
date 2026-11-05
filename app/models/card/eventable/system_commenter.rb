class Card::Eventable::SystemCommenter
  include ERB::Util

  attr_reader :card, :event

  def initialize(card, event)
    @card, @event = card, event
  end

  def comment
    return unless comment_body.present?

    card.comments.create! creator: card.account.system_user, body: comment_body, created_at: event.created_at
  end

  private
    def comment_body
      case event.action
      when "card_assigned"
        "#{creator_name} <strong>назначил(а)</strong> это на #{assignee_names}."
      when "card_unassigned"
        "#{creator_name} <strong>снял(а) назначение</strong> с #{assignee_names}."
      when "card_closed"
        "<strong>Перемещено</strong> в «Готово» пользователем #{creator_name}"
      when "card_reopened"
        "<strong>Вновь открыто</strong> пользователем #{creator_name}"
      when "card_postponed"
        "#{creator_name} <strong>переместил(а)</strong> это в «Не сейчас»"
      when "card_auto_postponed"
        "<strong>Перемещено</strong> в «Не сейчас» из-за бездействия"
      when "card_title_changed"
        "#{creator_name} <strong>изменил(а) заголовок</strong> с «#{old_title}» на «#{new_title}»."
      when "card_board_changed"
        "#{creator_name} <strong>переместил(а)</strong> это из «#{old_board}» в «#{new_board}»."
      when "card_triaged"
        "#{creator_name} <strong>переместил(а)</strong> это в «#{column}»"
      when "card_sent_back_to_triage"
        "#{creator_name} <strong>переместил(а)</strong> это обратно в «Возможно?»"
      end
    end

    def creator_name
      h event.creator.name
    end

    def assignee_names
      h event.assignees.pluck(:name).to_sentence
    end

    def old_title
      h event.particulars.dig("particulars", "old_title")
    end

    def new_title
      h event.particulars.dig("particulars", "new_title")
    end

    def old_board
      h event.particulars.dig("particulars", "old_board")
    end

    def new_board
      h event.particulars.dig("particulars", "new_board")
    end

    def column
      h event.particulars.dig("particulars", "column")
    end
end
