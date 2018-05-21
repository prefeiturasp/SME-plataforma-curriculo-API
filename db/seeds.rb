if Rails.env.development?
  User.create!(
    email: 'admin@jurema.la',
    password: 'senhasegura',
    password_confirmation: 'senhasegura',
    superadmin: true
  )
end

ActivityType.create(
  [
    { name: 'Exterior' },
    { name: 'Interior' }
  ]
)

CurricularComponent.create(
  [
    { name: 'Arte' },
    { name: 'Ciências Naturais' },
    { name: 'Educação Física' },
    { name: 'Geografia' },
    { name: 'História' },
    { name: 'Língua Portuguesa' },
    { name: 'Língua Inglesa' },
    { name: 'Matemática' },
    { name: 'Tecnologias de Aprendizagem' }
  ]
)

[
  {
    sequence: 1,
    name: 'Erradicação da Pobreza',
    description: 'Acabar com a pobreza em todas as suas formas, em todos os lugares',
    goals: 'goals example;'
  },
  {
    sequence: 2,
    name: 'Fome zera e agricultura sustentável',
    description: 'Acabar com a fome, alcançar a segurança alimentar e melhoria da nutrição
     e promover a agricultura sustentável',
    goals: 'goals example;'
  },
  {
    sequence: 3,
    name: 'Saúde e Bem Estar',
    description: 'Assegurar uma vida saudável e promover o bem-estar para todos, em todas as idades',
    goals: 'goals example;'
  },
  {
    sequence: 4,
    name: 'Educação de Qualidade',
    description: 'Assegurar a educação inclusiva e equitativa e de qualidade, e promover
     oportunidades de aprendizagem ao longo da vida para todos',
    goals: 'goals example;'
  },
  {
    sequence: 5,
    name: 'Igualdade de Genêro',
    description: 'Alcançar a igualdade de gênero e empoderar todas as mulheres e meninas',
    goals: 'goals example;'
  },
  {
    sequence: 6,
    name: 'Água Portável e Saneamento',
    description: 'Assegurar a disponibilidade e gestão sustentável da água e saneamento para todos',
    goals: 'goals example;'
  },
  {
    sequence: 7,
    name: 'Energia Limpa e Acessível',
    description: 'Assegurar o acesso confiável, sustentável, moderno e a preço acessível à energia para todos',
    goals: 'goals example;'
  },
  {
    sequence: 8,
    name: 'Trabalho decente e crescimento econômico',
    description: 'Promover o crescimento econômico sustentado, inclusivo e sustentável, emprego pleno e
     produtivo e trabalho decente para todos',
    goals: 'goals example;'
  },
  {
    sequence: 9,
    name: 'Indústria, inovação, e infraestrutura',
    description: 'Construir infraestruturas resilientes, promover a industrialização inclusiva e
     sustentável e fomentar a inovação',
    goals: 'goals example;'
  },
  {
    sequence: 10,
    name: 'Redução das desigualdades',
    description: 'Reduzir a desigualdade dentro dos países e entre eles',
    goals: 'goals example;'
  },
  {
    sequence: 11,
    name: 'Cidades e comunidades sustentáveis',
    description: 'Tornar as cidades e os assentamentos humanos inclusivos, seguros, resilientes e sustentáveis',
    goals: 'goals example;'
  },
  {
    sequence: 12,
    name: 'Consumo e produção responsáveis',
    description: 'Assegurar padrões de produção e de consumo sustentáveis',
    goals: 'goals example;'
  },
  {
    sequence: 13,
    name: 'Ação contra a mudança global do clima',
    description: 'Tomar medidas urgentes para combater a mudança do clima e seus impactos',
    goals: 'goals example;'
  },
  {
    sequence: 14,
    name: 'Vida na água',
    description: 'Conservação e uso sustentável dos oceanos, dos mares e dos recursos marinhos para o
     desenvolvimento sustentável',
    goals: 'goals example;'
  },
  {
    sequence: 15,
    name: 'Vida terrestre',
    description: 'Proteger, recuperar e promover o uso sustentável dos ecossistemas terrestres, gerir
     de forma sustentável as florestas, combater a desertificação, deter e reverter a degradação da terra
      e deter a perda de biodiversidade',
    goals: 'goals example;'
  },
  {
    sequence: 16,
    name: 'Paz, justiça e instituições eficazes',
    description: 'Promover sociedades pacíficas e inclusivas para o desenvolvimento sustentável,
     proporcionar o acesso à justiça para todos e construir instituições eficazes, responsáveis e
      inclusivas em todos os níveis',
    goals: 'goals example;'
  },
  {
    sequence: 17,
    name: 'Parcerias e meios de implementação',
    description: 'Fortalecer os meios de implementação e revitalizar a parceria global para o
     desenvolvimento sustentável',
    goals: 'goals example;'
  }
].each do |attributes|
  sequence = attributes[:sequence]
  sdg = SustainableDevelopmentGoal.new(attributes)
  sdg.goals = File.read("public/seeds/obj#{sequence}")
  sdg.icon.attach(
    io: File.open("public/seeds/obj#{sequence}.jpg"),
    filename: "obj#{sequence}.jpg",
    content_type: 'image/jpg'
  )
  sdg.save(validate: false)
end
