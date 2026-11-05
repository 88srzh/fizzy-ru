module Card::Promptable
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end

  def to_prompt
    <<~PROMPT
      BEGIN OF CARD #{id}

      **Заголовок:** #{title.first(1000)}
      **Описание:**

      #{description.to_plain_text.first(10_000)}

      #### Метаданные

      * Id: #{id}
      * Создано: #{creator.name}}
      * Назначено: #{assignees.map(&:name).join(", ")}
      * Колонка: #{column_prompt_label}
      * Создано в: #{created_at}}
      * Id доски: #{board_id}
      * Название доски: #{board.name}
      * Количество комментариев: #{comments.count}
      * Путь: #{card_path(self, script_name: account.slug)}

      END OF CARD #{id}
    PROMPT
  end

  private
    def column_prompt_label
      if open?
        if postponed?
          "Не сейчас"
        elsif triaged?
          "#{column&.name}"
        else
          "Возможно?"
        end
      else
        "Закрыто (пользователем #{closed_by&.name} в #{closed_at})"
      end
    end
end
