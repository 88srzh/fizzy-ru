Color = Struct.new(:name, :value)

class Color
  class << self
    # Finds a Color by its CSS value (e.g. "var(--color-card-4)").
    # Falls back to extracting the value from legacy export formats where
    # the Color struct was serialized instead of the raw CSS string.
    def for_value(value)
      COLORS.find { |it| it.value == value } ||
        extract_from_legacy_export(value)
    end

    private
      # Broken exports serialized Color structs instead of raw CSS values,
      # producing JSON like {"name":"Lime","value":"var(--color-card-4)"}.
      # Parse it and extract the value.
      def extract_from_legacy_export(value)
        parsed = value.is_a?(String) && JSON.parse(value)
        COLORS.find { |it| it.value == parsed["value"] } if parsed.is_a?(Hash)
      rescue JSON::ParserError
      end
  end

  def to_s
    value
  end

  COLORS = {
    "Синий" => "var(--color-card-default)",
    "Серый" => "var(--color-card-1)",
    "Бежевый" => "var(--color-card-2)",
    "Жёлтый" => "var(--color-card-3)",
    "Лаймовый" => "var(--color-card-4)",
    "Бирюзовый" => "var(--color-card-5)",
    "Фиолетовый" => "var(--color-card-6)",
    "Пурпурный" => "var(--color-card-7)",
    "Розовый" => "var(--color-card-8)"
  }.collect { |name, value| new(name, value) }.freeze
end
