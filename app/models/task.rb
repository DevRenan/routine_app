class Task < ApplicationRecord
  belongs_to :category
  belongs_to :frequency

  validates :title, presence: true
  validates :weight, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # A task está concluída dentro do ciclo atual?
  def completed?(now = Time.current)
    return false if completed_at.nil?

    case frequency.title
    when "Diária"
      # Concluída no mesmo dia de hoje
      completed_at.to_date == now.to_date

    when "A cada dois dias"
      # Reseta após 2 dias do dia da conclusão (ex: feita dia 20, fica feita dia 20 e 21, reseta dia 22)
      now.to_date < completed_at.to_date + 2.days

    when "A cada três dias"
      # Reseta após 3 dias do dia da conclusão (ex: feita dia 20, fica feita 20, 21 e 22, reseta dia 23)
      now.to_date < completed_at.to_date + 3.days

    when "Semanal"
      # Concluída dentro da semana atual (Segunda a Domingo)
      window = frequency.current_window(now)
      completed_at >= window[:start_at] && completed_at <= window[:end_at]

    when "A cada duas Semanas"
      # Concluída na janela atual de 2 semanas
      window = frequency.current_window(now)
      completed_at >= window[:start_at] && completed_at <= window[:end_at]

    when "Mensal"
      # Concluída no mesmo mês e ano
      completed_at.month == now.month && completed_at.year == now.year

    else
      completed_at.to_date == now.to_date
    end
  end

  # Dias restantes para expirar o ciclo/fazer a tarefa novamente
  def days_remaining(now = Time.current)
    return 1 unless completed?

    case frequency.title
    when "Diária"
      1
    when "A cada dois dias"
      (completed_at.to_date + 2.days - now.to_date).to_i
    when "A cada três dias"
      (completed_at.to_date + 3.days - now.to_date).to_i
    else
      window = frequency.current_window(now)
      seconds_left = window[:end_at] - now
      seconds_left <= 0 ? 1 : (seconds_left / 1.day).ceil
    end
  end

  def dynamic_frequency_weight(now = Time.current)
    return frequency.weight if frequency.nil?

    Frequency.weight_for_days_remaining(days_remaining(now))
  end

  def total_weight(now = Time.current)
    weight + (category&.weight || 0) + dynamic_frequency_weight(now)
  end

  def toggle_completion!
    if completed?
      update!(completed_at: nil)
    else
      update!(completed_at: Time.current)
    end
  end
end