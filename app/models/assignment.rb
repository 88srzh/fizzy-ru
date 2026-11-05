class Assignment < ApplicationRecord
  LIMIT = 100

  belongs_to :account, default: -> { card.account }
  belongs_to :card, touch: true

  belongs_to :assignee, class_name: "User"
  belongs_to :assigner, class_name: "User"

  validate :within_limit, on: :create

  private
    def within_limit
      if card.assignments.count >= LIMIT
        errors.add(:base, "Карточка уже содержит максимальное число исполнителей: #{LIMIT}")
      end
    end
end
