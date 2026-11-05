module Filter::Summarized
  def summary
    [ index_summary, sort_summary, tag_summary, assignee_summary, creator_summary, terms_summary ].compact.to_sentence
  end

  private
    def index_summary
      unless indexed_by.all?
        indexed_by.humanize
      end
    end

    def sort_summary
      unless sorted_by.latest?
        sorted_by.humanize
      end
    end

    def tag_summary
      if tags.any?
        "#{tags.map(&:hashtag).to_choice_sentence}"
      end
    end

    def assignee_summary
      if assignees.any?
        "назначено: #{assignees.pluck(:name).to_choice_sentence}"
      elsif assignment_status.unassigned?
        "ни на кого не назначено"
      end
    end

    def terms_summary
      if terms.any?
        "совпадает с #{terms.map { |term| %Q("#{term}") }.to_sentence}"
      end
    end

    def creator_summary
      if creators.any?
        "добавлено: #{creators.pluck(:name).to_choice_sentence}"
      end
    end
end
