class Frequency < ApplicationRecord
  has_many :tasks, dependent: :nullify

  validates :title, presence: true, uniqueness: true
  validates :weight, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Retorna o início e o fim da janela do ciclo atual da frequência
  def current_window(reference_time = Time.current)
    case title
    when "Diária"
      beginning = reference_time.beginning_of_day
      ending = reference_time.end_of_day
    when "A cada dois dias"
      beginning = reference_time.beginning_of_day
      ending = (reference_time + 1.day).end_of_day
    when "A cada três dias"
      beginning = reference_time.beginning_of_day
      ending = (reference_time + 2.days).end_of_day
    when "Semanal"
      beginning = reference_time.beginning_of_week(:monday)
      ending = reference_time.end_of_week(:monday)
    when "A cada duas Semanas"
      beginning = reference_time.beginning_of_week(:monday)
      ending = (reference_time + 1.week).end_of_week(:monday)
    when "Mensal"
      beginning = reference_time.beginning_of_month
      ending = reference_time.end_of_month
    else
      beginning = reference_time.beginning_of_day
      ending = reference_time.end_of_day
    end

    { start_at: beginning, end_at: ending }
  end

  # Retorna o peso dinâmico com base nos dias restantes até o fim do ciclo
  def self.weight_for_days_remaining(days_remaining)
    if days_remaining <= 1
      find_by(title: "Diária")&.weight || 0
    elsif days_remaining <= 2
      find_by(title: "A cada dois dias")&.weight || 1
    elsif days_remaining <= 3
      find_by(title: "A cada três dias")&.weight || 2
    elsif days_remaining <= 7
      find_by(title: "Semanal")&.weight || 3
    elsif days_remaining <= 14
      find_by(title: "A cada duas Semanas")&.weight || 5
    else
      find_by(title: "Mensal")&.weight || 8
    end
  end
end