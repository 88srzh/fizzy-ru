module Comment::Promptable
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end

  def to_prompt
    <<~PROMPT
        BEGIN OF COMMENT #{id}

        **Содержание:**

        #{body.to_plain_text.first(5000)}

        #### Метаданные

        * Id: #{id}
        * Id карточки: #{card.number}
        * Заголовок карточки: #{card.title}
        * Создано: #{creator.name}}
        * Создано в: #{created_at}}
        * Path: #{card_path(card, anchor: ActionView::RecordIdentifier.dom_id(self), script_name: account.slug)}
        END OF COMMENT #{id}
      PROMPT
  end
end
