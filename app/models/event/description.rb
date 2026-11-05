class Event::Description
  include ActionView::Helpers::TagHelper
  include ERB::Util

  attr_reader :event, :user

  def initialize(event, user)
    @event = event
    @user = user
  end

  def to_html
    to_sentence(creator_tag, card_title_tag).html_safe
  end

  def to_plain_text
    to_sentence(creator_name, quoted(card.title)).html_safe
  end

  private
    def to_sentence(creator, card_title)
      if event.action.comment_created?
        comment_sentence(creator, card_title)
      else
        action_sentence(creator, card_title)
      end
    end

    def creator_tag
      tag.span data: { creator_id: event.creator.id } do
        tag.span("Вы", data: { only_visible_to_you: true }) +        tag.span(event.creator.name, data: { only_visible_to_others: true })
      end
    end

    def card_title_tag
      tag.span card.title, class: "txt-underline"
    end

    def creator_name
      h event.creator.name
    end

    def quoted(text)
      h %("#{text}")
    end

    def card
      @card ||= event.action.comment_created? ? event.eventable.card : event.eventable
    end

    def comment_sentence(creator, card_title)
      "#{creator} прокомментировал(а) #{card_title}"
    end

    def action_sentence(creator, card_title)
      case event.action
      when "card_assigned"
        assigned_sentence(creator, card_title)
      when "card_unassigned"
        unassigned_sentence(creator, card_title)
      when "card_published"
        "#{creator} добавил(а) #{card_title}"
      when "card_closed"
        %(#{creator} переместил(а) #{card_title} в "Готово")
      when "card_reopened"
        "#{creator} вновь открыл(а) #{card_title}"
      when "card_postponed"
        %(#{creator} переместил(а) #{card_title} в "Не сейчас")
      when "card_auto_postponed"
        %(#{card_title} перемещено в "Не сейчас" из-за бездействия)
      when "card_resumed"
        "#{creator} возобновил(а) #{card_title}"
      when "card_title_changed"
        renamed_sentence(creator, card_title)
      when "card_board_changed", "card_collection_changed"
        moved_sentence(creator, card_title)
      when "card_triaged"
        triaged_sentence(creator, card_title)
      when "card_sent_back_to_triage"
        %(#{creator} переместил(а) #{card_title} обратно в "Возможно?")
      end
    end

    def assigned_sentence(creator, card_title)
      if event.assignees.include?(user)
        "#{creator} возьмётся за #{card_title}"
      else
        "#{creator} назначил(а) #{assignee_names} на #{card_title}"
      end
    end

    def unassigned_sentence(creator, card_title)
      "#{creator} снял(а) назначение с #{unassigned_names} по карточке #{card_title}"
    end

    def renamed_sentence(creator, card_title)
      %(#{creator} переименовал(а) #{card_title} (было: "#{old_title}"))
    end

    def moved_sentence(creator, card_title)
      %(#{creator} переместил(а) #{card_title} в "#{new_location}")
    end

    def triaged_sentence(creator, card_title)
      %(#{creator} переместил(а) #{card_title} в "#{column}")
    end

    def assignee_names
      h event.assignees.pluck(:name).to_sentence
    end

    def unassigned_names
      h(event.assignees.include?(user) ? "себя" : assignee_names)
    end

    def old_title
      h event.particulars.dig("particulars", "old_title")
    end

    def new_location
      h(event.particulars.dig("particulars", "new_board") || event.particulars.dig("particulars", "new_collection"))
    end

    def column
      h event.particulars.dig("particulars", "column")
    end
end
