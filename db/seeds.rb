# rubocop:disable Style/AsciiComments
if Rails.env.development?
  User.create!(
    email: 'admin@jurema.la',
    password: 'senhasegura',
    password_confirmation: 'senhasegura'
  )
end

ActivityType.create(
  [
    { name: 'Exterior' },
    { name: 'Interior' },
    { name: 'Grupo' },
    { name: 'Individual' }
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
    description: 'Acabar com a pobreza em todas as suas formas, em todos os lugares'
  },
  {
    sequence: 2,
    name: 'Fome zera e agricultura sustentável',
    description: 'Acabar com a fome, alcançar a segurança alimentar e melhoria da nutrição
     e promover a agricultura sustentável'
  },
  {
    sequence: 3,
    name: 'Saúde e Bem Estar',
    description: 'Assegurar uma vida saudável e promover o bem-estar para todos, em todas as idades'
  },
  {
    sequence: 4,
    name: 'Educação de Qualidade',
    description: 'Assegurar a educação inclusiva e equitativa e de qualidade, e promover
     oportunidades de aprendizagem ao longo da vida para todos'
  },
  {
    sequence: 5,
    name: 'Igualdade de Genêro',
    description: 'Alcançar a igualdade de gênero e empoderar todas as mulheres e meninas'
  },
  {
    sequence: 6,
    name: 'Água Portável e Saneamento',
    description: 'Assegurar a disponibilidade e gestão sustentável da água e saneamento para todos'
  },
  {
    sequence: 7,
    name: 'Energia Limpa e Acessível',
    description: 'Assegurar o acesso confiável, sustentável, moderno e a preço acessível à energia para todos'
  },
  {
    sequence: 8,
    name: 'Trabalho decente e crescimento econômico',
    description: 'Promover o crescimento econômico sustentado, inclusivo e sustentável, emprego pleno e
     produtivo e trabalho decente para todos'
  },
  {
    sequence: 9,
    name: 'Indústria, inovação, e infraestrutura',
    description: 'Construir infraestruturas resilientes, promover a industrialização inclusiva e
     sustentável e fomentar a inovação'
  },
  {
    sequence: 10,
    name: 'Redução das desigualdades',
    description: 'Reduzir a desigualdade dentro dos países e entre eles'
  },
  {
    sequence: 11,
    name: 'Cidades e comunidades sustentáveis',
    description: 'Tornar as cidades e os assentamentos humanos inclusivos, seguros, resilientes e sustentáveis'
  },
  {
    sequence: 12,
    name: 'Consumo e produção responsáveis',
    description: 'Assegurar padrões de produção e de consumo sustentáveis'
  },
  {
    sequence: 13,
    name: 'Ação contra a mudança global do clima',
    description: 'Tomar medidas urgentes para combater a mudança do clima e seus impactos'
  },
  {
    sequence: 14,
    name: 'Vida na água',
    description: 'Conservação e uso sustentável dos oceanos, dos mares e dos recursos marinhos para o
     desenvolvimento sustentável'
  },
  {
    sequence: 15,
    name: 'Vida terrestre',
    description: 'Proteger, recuperar e promover o uso sustentável dos ecossistemas terrestres, gerir
     de forma sustentável as florestas, combater a desertificação, deter e reverter a degradação da terra
      e deter a perda de biodiversidade'
  },
  {
    sequence: 16,
    name: 'Paz, justiça e instituições eficazes',
    description: 'Promover sociedades pacíficas e inclusivas para o desenvolvimento sustentável,
     proporcionar o acesso à justiça para todos e construir instituições eficazes, responsáveis e
      inclusivas em todos os níveis'
  },
  {
    sequence: 17,
    name: 'Parcerias e meios de implementação',
    description: 'Fortalecer os meios de implementação e revitalizar a parceria global para o
     desenvolvimento sustentável'
  }
].each do |attributes|
  sequence = attributes[:sequence]
  sdg = SustainableDevelopmentGoal.new(attributes)
  File.read("public/seeds/obj#{sequence}").split(';').each do |goal|
    sdg.goals << Goal.create(description: goal)
  end

  sdg.icon.attach(
    io: File.open("public/seeds/obj#{sequence}.jpg"),
    filename: "obj#{sequence}.jpg",
    content_type: 'image/jpg'
  )
  sdg.save
end

KnowledgeMatrix.create(
  [
    { sequence: '1',
      title: 'Pensamento Científico, Crítico e Criativo',
      know_description: 'Acessar, selecionar e organizar o conhecimento com curiosidade, '\
        'pensamento científico, criticidade e criatividade;',
      for_description: 'Observar, questionar, investigar causas, elaborar e testar hipóteses; '\
        'refletir, interpretar e analisar ideias e fatos em profundidade; produzir e '\
        'utilizar evidências.' },
    { sequence: '2',
      title: 'Resolução de Problemas',
      know_description: 'Descobrir possibilidades diferentes, avaliar e gerenciar, ter '\
        'ideias originais e criar soluções, problemas e perguntas;',
      for_description: 'Inventar, reinventar-se, resolver problemas individuais e coletivos e '\
        'agir de forma propositiva em relação aos desa!os contemporâneos.' },
    { sequence: '3',
      title: 'Comunicação',
      know_description: 'Utilizar as linguagens verbal, verbo-visual, corporal, multimodal, '\
        'artística, matemática, científica, LIBRAS, tecnológica e digital para expressar-se, '\
        'partilhar informações, experiências, ideias e sentimentos em diferentes contextos e '\
        'produzir sentidos que levem ao entendimento mútuo;',
      for_description: 'Exercitar-se como sujeito dialógico, criativo e sensível, compartilhar '\
        'saberes, reorganizando o que já sabe e criando novos significados, e compreender o mundo, '\
        'situando-se em diferentes contextos socioculturais.' },
    { sequence: '4',
      title: 'Autoconhecimento e Autocuidado',
      know_description: 'Conhecer e cuidar de seu corpo, sua mente, suas emoções, suas aspirações
        e seu bem-estar e ter autocrítica;',
      for_description: 'Reconhecer limites, potências e interesses pessoais, apreciar suas próprias '\
        'qualidades, a fim de estabelecer objetivos de vida, evitar situações de risco, adotar '\
        'hábitos saudáveis, gerir suas emoções e comportamentos, dosar impulsos e saber lidar com '\
        'a influência de grupos.' },
    { sequence: '5',
      title: 'Autonomia e Determinação',
      know_description: 'Organizar-se, definir metas e perseverar para alcançar seus objetivos;',
      for_description: 'Agir com autonomia e responsabilidade, fazer escolhas, vencer obstáculos '\
        'e ter confiança para planejar e realizar projetos pessoais, profissionais e de interesse '\
        'coletivo.' },
    { sequence: '6',
      title: 'Abertura à Diversidade',
      know_description: 'Abrir-se ao novo, respeitar e valorizar diferenças e acolher a diversidade;',
      for_description: 'Agir com "exibilidade e sem preconceito de qualquer natureza, conviver '\
        'harmonicamente com os diferentes, apreciar, fruir e produzir bens culturais diversos, '\
        'valorizar as identidades e culturas locais.' },
    { sequence: '7',
      title: 'Responsabilidade e Participação',
      know_description: 'Reconhecer e exercer direitos e deveres, tomar decisões éticas e
        responsáveis para consigo, o outro e o planeta;',
      for_description: 'Agir de forma solidária, engajada e sustentável, respeitar e promover os '\
        'direitos humanos e ambientais, participar da vida cidadã e perceber-se como agente de '\
        'transformação.' },
    { sequence: '8',
      title: 'Empatia e Colaboração',
      know_description: 'Considerar a perspectiva e os sentimentos do outro, colaborar com os '\
        'demais e tomar decisões coletivas;',
      for_description: 'Agir com empatia, trabalhar em grupo, criar, pactuar e respeitar princípios '\
        'de convivência, solucionar conflitos, desenvolver a tolerância à frustração e promover a '\
        'cultura da paz.' },
    { sequence: '9',
      title: 'Repertório Cultural',
      know_description: 'Desenvolver repertório cultural e senso estético para reconhecer, '\
        'valorizar e fruir as diversas identidades e manifestações artísticas e culturais e '\
        'participar de práticas diversificadas de produção sociocultural;',
      for_description: 'Ampliar e diversificar suas possibilidades de acesso a produções culturais '\
        'e suas experiências emocionais, corporais, sensoriais, expressivas, cognitivas, sociais e '\
        'relacionais, desenvolvendo seus conhecimentos, sua imaginação, criatividade, percepção, '\
        'intuição e emoção.' }
  ]
)
# rubocop:enable Style/AsciiComments
