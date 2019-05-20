if Rails.env.development?
  admin = User.find_or_create_by(email: 'admin@jurema.la')
  admin.password = 'qwe123'
  admin.password_confirmation = 'qwe123'
  admin.save
end

#[
#  { name: 'Grupo' },
#  { name: 'Individual' },
#  { name: 'Dupla' }
#].each do |attributes|
#  ActivityType.find_or_create_by(attributes)
#end

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
].each do |attributes|
  cc = CurricularComponent.find_or_create_by(attributes)
  cc.color = Faker::Color.hex_color
  cc.save
end

[
  {
    sequence: 1,
    name: 'Erradicação da Pobreza',
    description: 'Acabar com a pobreza em todas as suas formas, em todos os lugares',
    color: '#ff1f39'
  },
  {
    sequence: 2,
    name: 'Fome zero e agricultura sustentável',
    description: 'Acabar com a fome, alcançar a segurança alimentar e melhoria da nutrição
     e promover a agricultura sustentável',
    color: '#eea72b'
  },
  {
    sequence: 3,
    name: 'Saúde e Bem Estar',
    description: 'Assegurar uma vida saudável e promover o bem-estar para todos, em todas as idades',
    color: '#009f29'
  },
  {
    sequence: 4,
    name: 'Educação de Qualidade',
    description: 'Assegurar a educação inclusiva e equitativa e de qualidade, e promover
     oportunidades de aprendizagem ao longo da vida para todos',
    color: '#e6132a'
  },
  {
    sequence: 5,
    name: 'Igualdade de Genêro',
    description: 'Alcançar a igualdade de gênero e empoderar todas as mulheres e meninas',
    color: '#ff3718'
  },
  {
    sequence: 6,
    name: 'Água Portável e Saneamento',
    description: 'Assegurar a disponibilidade e gestão sustentável da água e saneamento para todos',
    color: '#00bee4'
  },
  {
    sequence: 7,
    name: 'Energia Limpa e Acessível',
    description: 'Assegurar o acesso confiável, sustentável, moderno e a preço acessível à energia para todos',
    color: '#ffc400'
  },
  {
    sequence: 8,
    name: 'Trabalho decente e crescimento econômico',
    description: 'Promover o crescimento econômico sustentado, inclusivo e sustentável, emprego pleno e
     produtivo e trabalho decente para todos',
    color: '#be1341'
  },
  {
    sequence: 9,
    name: 'Indústria, inovação, e infraestrutura',
    description: 'Construir infraestruturas resilientes, promover a industrialização inclusiva e
     sustentável e fomentar a inovação',
    color: '#ff680b'
  },
  {
    sequence: 10,
    name: 'Redução das desigualdades',
    description: 'Reduzir a desigualdade dentro dos países e entre eles',
    color: '#fb126b'
  },
  {
    sequence: 11,
    name: 'Cidades e comunidades sustentáveis',
    description: 'Tornar as cidades e os assentamentos humanos inclusivos, seguros, resilientes e sustentáveis',
    color: '#ff9e00'
  },
  {
    sequence: 12,
    name: 'Consumo e produção responsáveis',
    description: 'Assegurar padrões de produção e de consumo sustentáveis',
    color: '#ca8916'
  },
  {
    sequence: 13,
    name: 'Ação contra a mudança global do clima',
    description: 'Tomar medidas urgentes para combater a mudança do clima e seus impactos',
    color: '#007f3f'
  },
  {
    sequence: 14,
    name: 'Vida na água',
    description: 'Conservação e uso sustentável dos oceanos, dos mares e dos recursos marinhos para o
     desenvolvimento sustentável',
    color: '#0098dc'
  },
  {
    sequence: 15,
    name: 'Vida terrestre',
    description: 'Proteger, recuperar e promover o uso sustentável dos ecossistemas terrestres, gerir
     de forma sustentável as florestas, combater a desertificação, deter e reverter a degradação da terra
      e deter a perda de biodiversidade',
    color: '#00c614'
  },
  {
    sequence: 16,
    name: 'Paz, justiça e instituições eficazes',
    description: 'Promover sociedades pacíficas e inclusivas para o desenvolvimento sustentável,
     proporcionar o acesso à justiça para todos e construir instituições eficazes, responsáveis e
      inclusivas em todos os níveis',
    color: '#0068a0'
  },
  {
    sequence: 17,
    name: 'Parcerias e meios de implementação',
    description: 'Fortalecer os meios de implementação e revitalizar a parceria global para o
     desenvolvimento sustentável',
    color: '#00466b'
  }
].each do |attributes|
  sequence = attributes[:sequence]
  sdg = SustainableDevelopmentGoal.find_or_create_by(sequence: attributes[:sequence])
  sdg.icon.purge
  sdg.sub_icon.purge
  sdg.icon.attach(
    io: File.open("public/seeds/obj#{sequence}.jpg"),
    filename: "obj#{sequence}.jpg",
    content_type: 'image/jpg'
  )

  # TODO: change to sub_icon image
  sdg.sub_icon.attach(
    io: File.open("public/seeds/sub_icon#{sequence}.png"),
    filename: "sub_icon#{sequence}.png",
    content_type: 'image/png'
  )
  File.read("public/seeds/obj#{sequence}").split(';').each do |goal|
    sdg.goals << Goal.find_or_create_by(description: goal)
  end
  sdg.update_attributes(attributes)
end

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
].each do |attributes|
  know = KnowledgeMatrix.find_or_create_by(sequence: attributes[:sequence])
  know.update_attributes(attributes)
end

CurricularComponent.all.each do |curricular_component|
  (1..3).each do |i|
    Axis.create(description: "Eixo #{i} - #{curricular_component.name}", curricular_component_id: curricular_component.id)
  end
end

[
  {
    sequence: 1,
    description: 'Como você avalia a qualidade do conteúdo?'
  },
  {
    sequence: 2,
    description: 'E a metodologia aplicada?'
  },
  {
    sequence: 3,
    description: 'Qual foi o nível de envolvimento dos estudantes com as Atividades?'
  }
].each do |rating_params|
  rating = Rating.find_or_create_by(sequence: rating_params[:sequence])
  rating.description = rating_params[:description]
  rating.save
end

Rake::Task['db:seed:create_or_update_content_blocks'].invoke

if Rails.env.development?
  Rake::Task['db:seed:create_or_update_teachers'].invoke
  Rake::Task['db:seed:create_or_update_learning_objectives'].invoke
  Rake::Task['db:seed:create_or_update_challenges'].invoke
  Rake::Task['db:seed:create_or_update_results'].invoke
  Rake::Task['db:seed:create_or_update_methodologies'].invoke
end
