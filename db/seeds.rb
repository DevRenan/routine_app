# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
categories = [
  { title: "Estudo/Carreira/Graduação", weight: 0, color: "#22C55E" },
  { title: "Saúde/Treinos/AutoEstima", weight: 1, color: "#3B82F6" },
  { title: "Manutenção Casa/Organização Vida", weight: 2, color: "#9CA3AF" },
  { title: "Habilidades Autosuficientes/Cultura/Política", weight: 3, color: "#EF4444" },
  { title: "Família", weight: 5, color: "#F97316" },
  { title: "Outros", weight: 8, color: "#8B5CF6" }
]

categories.each do |record|
  category = Category.find_or_initialize_by(title: record[:title])

  category.weight = record[:weight]
  category.color = record[:color]

  category.save!
end

puts "Categorias cadastradas com sucesso!"
puts "Categorias cadastradas com sucesso!"


# 1. População e atualização das Frequências com os pesos exatos
frequencies_data = [
  { title: "Diária", weight: 0 },
  { title: "A cada dois dias", weight: 1 },
  { title: "A cada três dias", weight: 2 },
  { title: "Semanal", weight: 3 },
  { title: "A cada duas Semanas", weight: 5 },
  { title: "Mensal", weight: 8 }
]

frequencies = {}
frequencies_data.each do |data|
  frequencies[data[:title]] = Frequency.find_or_create_by!(title: data[:title]) do |f|
    f.weight = data[:weight]
  end
  # Atualiza o peso caso a frequência já existisse no banco
  frequencies[data[:title]].update!(weight: data[:weight])
end

# 2. Categoria "Manutenção Casa/Organização Vida" (Peso 2)
category = Category.find_or_create_by!(title: "Manutenção Casa/Organização Vida") do |c|
  c.weight = 2
end

# 3. Lista de Tarefas associadas diretamente pelo nome da Frequência
tasks_data = [
  { title: "Lavar louça do dia", frequency_title: "Diária" },
  { title: "Organizar e secar pia todo fim de dia", frequency_title: "Diária" },
  { title: "Fazer Mercado", frequency_title: "Semanal" },
  { title: "Organizar mesa Sala", frequency_title: "Semanal" },
  { title: "Organizar mesa escritório", frequency_title: "A cada duas Semanas" },
  { title: "Verificar validade dos alimentos (Cortar frutas)", frequency_title: "Semanal" },
  { title: "Aspirar o chão da sala", frequency_title: "A cada dois dias" },
  { title: "Aspirar o chão do escritório", frequency_title: "A cada dois dias" },
  { title: "Aspirar o chão do quarto", frequency_title: "A cada dois dias" },
  { title: "Lavar o banheiro social", frequency_title: "Semanal" },
  { title: "Lavar o box do banheiro social", frequency_title: "Semanal" },
  { title: "Lavar o box do banheiro suíte", frequency_title: "Semanal" },
  { title: "Limpar o espelho da entrada", frequency_title: "Semanal" },
  { title: "Limpar o espelho do quarto", frequency_title: "Semanal" },
  { title: "Limpar o espelho do banheiro social", frequency_title: "Semanal" },
  { title: "Limpar o espelho do banheiro suíte", frequency_title: "Semanal" },
  { title: "Limpar o Jarbas", frequency_title: "Semanal" },
  { title: "Passar pano no chão da Sala", frequency_title: "Semanal" },
  { title: "Passar pano no chão do quarto", frequency_title: "Semanal" },
  { title: "Passar pano no chão do escritório", frequency_title: "Semanal" },
  { title: "Passar pano na entrada do apartamento", frequency_title: "Semanal" },
  { title: "Aspirar e limpar o sofá", frequency_title: "A cada duas Semanas" },
  { title: "Limpar Mesa, bancada e banco alemão", frequency_title: "A cada três dias" },
  { title: "Limpar pia cozinha", frequency_title: "A cada dois dias" },
  { title: "Limpar pia lavanderia", frequency_title: "Semanal" },
  { title: "Limpar vidro sacada", frequency_title: "A cada duas Semanas" },
  { title: "Limpar porta sacada", frequency_title: "A cada duas Semanas" },
  { title: "Limpar Janela quarto", frequency_title: "Mensal" },
  { title: "Limpar Janela escritório", frequency_title: "Mensal" },
  { title: "Varrer área técnica", frequency_title: "A cada duas Semanas" },
  { title: "Limpar geladeira", frequency_title: "A cada duas Semanas" },
  { title: "Limpar fogão e forno", frequency_title: "Semanal" },
  { title: "Limpar microondas", frequency_title: "Semanal" },
  { title: "Organização financeira", frequency_title: "Semanal" },
  { title: "Organização das ideias", frequency_title: "Semanal" }
]

# 4. Criar ou atualizar as Tasks
tasks_data.each do |task_info|
  target_frequency = frequencies[task_info[:frequency_title]]

  task = Task.find_or_create_by!(title: task_info[:title], category: category) do |t|
    t.description = "Tarefa de manutenção e organização rotineira"
    t.weight = 1
    t.frequency = target_frequency
  end

  task.update!(frequency: target_frequency)
end

puts "Frequências atualizadas, Categoria garantida e #{tasks_data.size} Tasks cadastradas com sucesso!"


# db/seeds.rb

# 1. Buscar/Garantir a Categoria "Estudo/Carreira/Graduação" (Peso 0)
estudo_category = Category.find_or_create_by!(title: "Estudo/Carreira/Graduação") do |c|
  c.weight = 0
  c.color = "#22C55E" # Verde
end

# 2. Buscar/Garantir a Frequência "Diária" (Peso 0)
daily_frequency = Frequency.find_or_create_by!(title: "Diária") do |f|
  f.weight = 0
end

# 3. Criar 16 registros da tarefa "30 minutos Estudo / Carreira / Graduação"
16.times do |i|
  # Usando find_or_create_by! especificando a iteração na descrição para garantir a criação das 16 instâncias sem duplicidade
  Task.find_or_create_by!(
    title: "30 minutos Estudo / Carreira / Graduação",
    description: "Bloco de estudo/carreira ##{i + 1}",
    category: estudo_category,
    frequency: daily_frequency
  ) do |t|
    t.weight = 0
  end
end

puts "16 tarefas de Estudo / Carreira / Graduação criadas com sucesso!"