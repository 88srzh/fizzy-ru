module WebhooksHelper
  ACTION_LABELS = {
    card_published: "Карточка добавлена",
    card_title_changed: "Название карточки изменено",
    card_board_changed: "Доска карточки изменена",
    comment_created: "Комментарий добавлен",
    card_assigned: "Карточка назначена",
    card_unassigned: "Назначение карточки снято",
    card_triaged: "Колонка карточки изменена",
    card_closed: "Карточка перемещена в «Готово»",
    card_reopened: "Карточка вновь открыта",
    card_postponed: "Карточка перемещена в «Не сейчас»",
    card_auto_postponed: "Карточка перемещена в «Не сейчас» из-за неактивности",
    card_sent_back_to_triage: "Карточка возвращена в «Возможно?»"
  }.with_indifferent_access.freeze

  def webhook_action_options(actions = Webhook::PERMITTED_ACTIONS)
    ACTION_LABELS.select { |key, _| actions.include?(key.to_s) }
  end

  def webhook_action_label(action)
    ACTION_LABELS[action] || action.to_s.humanize
  end

  # A client swept after its last grant ended (Oauth::Client.cleanup) leaves
  # no name behind, but the webhook it set up still came from an app.
  def webhook_attribution(webhook)
    if webhook.creator
      if webhook.created_via_id?
        "Создано пользователем #{webhook.creator.name} через #{webhook_app_name(webhook)}"
      else
        "Создано пользователем #{webhook.creator.name}"
      end
    end
  end

  def webhook_app_name(webhook)
    webhook.created_via&.name || "приложение, которое с тех пор удалено"
  end

  def link_to_webhooks(board, &)
    link_to board_webhooks_path(board_id: board),
        class: [ "btn btn--circle-mobile", { "btn--reversed": board.webhooks.any? } ],
        data: { controller: "tooltip", bridge__overflow_menu_target: "item", bridge_title: "Вебхуки" } do
      icon_tag("world") + tag.span("Вебхуки", class: "for-screen-reader")
    end
  end
end
