module Event::Promptable
  extend ActiveSupport::Concern

  def to_prompt
    <<~PROMPT
        BEGIN OF EVENT #{id}
        ## Событие #{action} (#{eventable_type} #{eventable_id}))

        * Создано в: #{created_at}
        * Создано: #{creator.name}

        #{eventable.to_prompt}
        END OF EVENT #{id}
      PROMPT
  end
end
