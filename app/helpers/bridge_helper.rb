module BridgeHelper
  def bridge_icon(name)
    asset_url("#{name}.svg")
  end

  def bridged_button_to_board(board)
    link_to "Перейти к #{board.name}", board, hidden: true, data: {
      bridge__buttons_target: "button",
      bridge_icon_url: bridge_icon("board"),
      bridge_title: "Перейти к #{board.name}"
    }
  end

  def bridged_share_url_button(description = nil)
    tag.button "Поделиться", hidden: true, data: {
      controller: "bridge--share",
      action: "bridge--share#shareUrl",
      bridge__overflow_menu_target: "item",
      bridge_title: "Поделиться",
      bridge_share_description: description
    }
  end

  def bridge_share_card_description(card)
    date_added = card.created_at.strftime("%b %e")
    date_updated = card.last_active_at.strftime("%b %e")
    author = card.creator.familiar_name
    assignees = card.assignees.any? ? "назначено: #{card.assignees.map { |assignee| h assignee.familiar_name }.to_sentence}" : "не назначено"
    "Добавлено #{date_added} пользователем #{author}, #{assignees}. Обновлено #{date_updated}"
  end

  def bridge_share_board_description(board)
    count_open = board.cards.active.count
    count_in_stream = board.cards.awaiting_triage.count
    "#{count_open} открытых карточек, #{count_in_stream} в «Возможно?»"
  end
end
