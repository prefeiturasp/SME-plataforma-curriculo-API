namespace :db do
  namespace :seed do

    def create_content_block kind
      return unless [:bullet, :open_text, :gallery].include? kind

      lines          = rand 3..9
      content_blocks = ContentBlock.where(content_type: [:bullet, :open_text, :gallery])
        .pluck(:id, :content_type).map{|id,type| {type.to_sym => id}}.reduce(:merge)

      formulas = ['F(x)=\\int_b^a\\frac{1}{3}x^3', 'e\ =\ mc^2', 'x=-b\\pm \\sqrt b^2 -4ac']

      return {
        'content_block_id' => content_blocks[:open_text],
        'content'          => {
          title: Faker::Lorem.sentence,
          body:  {
            ops: [
              { insert: Array.new(rand(2..5)) { Faker::Lorem.sentence(rand(5..10)) }.join("\n") },
              [{ insert: "\n" }, { insert: { formula: formulas.shuffle!.pop } }, { insert: "\n" }],
              { insert: Array.new(rand(2..5)) { Faker::Lorem.sentence(rand(5..10)) }.join("\n") },
              [{ insert: "\n" }, { insert: { formula: formulas.shuffle!.pop } }, { insert: "\n" }]
            ].shuffle.flatten
          }.to_json
        }.to_json
      } if kind == :open_text

      return {
        'content_block_id' => content_blocks[:bullet],
        'content'          => {
          title: Faker::Lorem.sentence,
          body:  {
            ops: Array.new(lines) { {insert: Faker::Lorem.sentence} }
                   .zip(Array.new(lines) { {attributes: {list: :bullet}, insert: "\n"} })
                   .flatten
          }.to_json
        }.to_json
      } if kind == :bullet

      { content_block_id: content_blocks[:gallery], content: '' }
    end

    def create_challenge_result teacher, challenge, class_name = nil
      result = Result.create!(
        class_name:   class_name.blank? ? Faker::Lorem.sentence : class_name,
        description:  Faker::Lorem.sentence(200),
        teacher_id:   teacher,
        challenge_id: challenge
      )

      rand(1..2).times do
        result.links.create! link: Faker::Internet.url
      end

      rand(0..4).times do
        document = ['1.jpg', '2.jpg', '3.jpg', '4.jpg', 'sample.doc', 'sample.pdf', false].sample

        next unless document

        result.archives.attach(
          io:       File.open(Rails.root.join('spec', 'fixtures', 'activities', document)),
          filename: document
        ) unless ['sample.doc', 'sample.pdf'].include? document

        result.archives.attach(
          filename: document,
          io:       File.open(Rails.root.join('spec', 'fixtures', 'documents', document))
        ) if ['sample.doc', 'sample.pdf'].include? document
      end
    end

    desc "Create or Update Teachers"
    task create_or_update_teachers: :environment do
      [
        'prof@jurema.la', 'prof1@jurema.la', 'prof2@jurema.la', 'prof3@jurema.la'
      ].each do |email|
        user = FactoryBot.build :user

        user.username = email.split("@").first
        user.email    = email
        user.password = "qwe123"

        User.where(email: email).first_or_create.update(
          user.as_json.reject{|k,v| v.blank?}.merge(admin: false)
        )

        if Teacher.joins(:user).where(users: { email: email }).blank?
          teacher = Teacher.create!(
            user:     User.where(email: email).first,
            nickname: Faker::Internet.user_name(7..15),
            name:     Faker::Name.unique.name
          )

          teacher.avatar.attach(
            io:       File.open(Rails.root.join('spec', 'factories', 'images', 'ruby.png')),
            filename: 'ruby.png'
          )
        end
      end
    end

    desc "Create or Update Learning Objectives"
    task create_or_update_learning_objectives: :environment do
      sustainables         = SustainableDevelopmentGoal.pluck :id
      curricular_component = CurricularComponent.all
      cc_index = {
        'matematica': 'MA', 'lingua-inglesa':  'LI', 'lingua-portuguesa': 'LP', 'historia': 'HI',
        'geografia':  'GE', 'educacao-fisica': 'EF', 'ciencias-naturais': 'CI', 'arte':     'AR'
      }

      curricular_component.each do |cc|
        next unless cc_index[cc.slug.to_sym]

        next unless LearningObjective.joins(:curricular_component)
                      .where(curricular_components: { slug: cc.slug }).blank?

        year = rand 1..9
        code = [0, 12, 12, 35, 35, 35, 67, 67, 89, 89][year]

        if ['lingua-portuguesa', 'arte'].include? cc.slug
          code = (year > 0 and year < 6) ? 15 : 69
        end

        code = "EF#{code}#{cc_index[cc.slug.to_sym]}#{rand(1..33).to_s.rjust(2, '0')}"

        LearningObjective.create!(
          year:                             year,
          description:                      Faker::Lorem.sentence(20),
          code:                             code,
          curricular_component:             cc,
          sustainable_development_goal_ids: sustainables.sample(rand(2..4)),
          axis_ids:                         cc.axes.pluck(:id).sample
        )
      end
    end

    desc "Create or Update Challenges"
    task create_or_update_challenges: :environment do
      categories            = [:project, :make_and_remake, :games, :investigation]
      knowledge_matrices    = KnowledgeMatrix.pluck :id
      learning_objectives   = LearningObjective.pluck(:curricular_component_id, :id)
                                .map{|ccid,id| {ccid => id}}.reduce(:merge)
      curricular_components = CurricularComponent.pluck(:slug, :id)
                                .map{|slug,id| {slug => id}}.reduce(:merge)

      index = 0
      # title => curricular component
      {
        'Legenda de filmes'        => 'lingua-inglesa',
        'Cartografia popular'      => 'geografia',
        'Feira de ciencias'        => 'ciencias-naturais',
        'Sarau e Poesia'           => 'lingua-portuguesa',
        'Esporte e Saude'          => 'educacao-fisica',
        'Arte e Cultura'           => 'arte',
        'Olimpiadas de Matematica' => 'matematica',
        'Quiz de Historia'         => 'historia'
      }.each do |title, cc|
        index += 1

        next unless Challenge.where(title: title).blank?

        ccx  = curricular_components[cc]
        ends = index % 2 == 0 ? Faker::Date.backward(rand(10..100)) : Faker::Date.forward(rand(60..1000))

        challenge = Challenge.create!(
          title:                    title,
          keywords:                 Faker::Lorem.words.join(', '),
          finish_at:                ends,
          category:                 categories.sample,
          status:                   (index > 3 && 6 < index ? :draft : :published),
          curricular_component_ids: [ccx],
          knowledge_matrix_ids:     knowledge_matrices.sample(1),
          learning_objective_ids:   learning_objectives[ccx]
        )

        challenge.image.attach(
          io:       File.open(Rails.root.join('spec', 'fixtures', 'activities', "#{[1, 2, 3, 4].sample}.jpg")),
          filename: 'challenge.jpg'
        )

        rand(1..2).times do
          challenge.challenge_content_blocks.create! create_content_block([:open_text, :bullet].sample)
        end
      end
    end

    desc "Create or Update Results"
    task create_or_update_results: :environment do
      teachers   = Teacher.pluck :id
      challenges = Challenge.pluck :id
      challenge  = Challenge.find 'feira-de-ciencias'

      challenges.each do |cid|
        next unless Result.where(challenge_id: cid).blank?

        create_challenge_result teachers.sample, cid
      end

      [
        '5º serie B - EMEF Luis Carlos Prestes',
        '4º serie A - EMEF Ulysses Guimaraes',
        '3º serie D - EMEF Leonel Brizola',
        '4º serie B - EMEF Luis Carlos Prestes',
        '3º serie A - EMEF Leonel Brizola',
        '2º serie D - EMEF Tarsila do Amaral',
        '3º serie H - EMEF Tarsila do Amaral',
        '2º serie E - EMEF Ulysses Guimaraes',
        '4º serie A - EMEF Tarsila do Amaral',
        '2º serie B - EMEF Getúlio Vargas',
        '3º serie F - EMEF Getúlio Vargas',
        '4º serie C - EMEF Getúlio Vargas'
      ].each do |class_name|
        next unless Result.where(class_name: class_name).blank?

        create_challenge_result teachers.sample, challenge.id, class_name
      end
    end

    desc "Create or Update Methodologies"
    task create_or_update_methodologies: :environment do
      [
        ['Projeto', 'project.svg'],
        ['Investigação', 'investigation.svg'],
        ['Jogos', 'games.svg'],
        ['Fazer e refazer', 'make.svg']
      ].each do |title, icon|
        next unless Methodology.where(title: title).blank?

        meth = Methodology.create! title: title, description: Faker::Lorem.sentence(140)

        meth.image.attach(
          io:       File.open(Rails.root.join('spec', 'fixtures', 'icons', icon)),
          filename: icon
        )

        if title == 'Projeto'
          [
            ['Ponto de partida', '1.svg'],
            ['Formação de equipes', '2.svg'],
            ['Definição do produto final', '3.svg'],
            ['Organização e planejamento', '4.svg'],
            ['Compilação de informação', '5.svg'],
            ['Análise e síntese', '6.svg'],
            ['Produção', '7.svg'],
            ['Apresentação do projeto', '8.svg'],
            ['Resposta coletiva à pergunta inicial', '9.svg'],
            ['Avaliação e autoavaliação', '10.svg']
          ].each do |step_title, step_icon|
            step = meth.steps.create! title: step_title, description: Faker::Lorem.sentence(140)

            step.image.attach(
              io:       File.open(Rails.root.join('spec', 'fixtures', 'steps', step_icon)),
              filename: step_icon
            )
          end
        else
          meth.content = JSON.parse(create_content_block(:open_text)['content'])['body']

          archive = ['sample.doc', 'sample.pdf', false].sample

          meth.archive.attach(
            io:       File.open(Rails.root.join('spec', 'fixtures', 'documents', archive)),
            filename: archive
          ) if archive

          meth.save!
        end
      end
    end

    desc "Create or Update Content Block"
    task create_or_update_content_blocks: :environment do
      [
        {
          "content_type": "to_teacher",
          "schema": {
            "required": ["body"],
            "properties": {
              "body": {
                "type": "string"
              }
            }
          }
        },
        {
          "content_type": "to_student",
          "schema": {
            "required": ["body"],
            "properties": {
              "body": {
                "type": "string"
              }
            }
          }
        },
        {
          "content_type": "question",
          "schema": {
            "required": ["title", "number", "body"],
            "properties": {
              "title": {
                "type": "string"
              },
              "number": {
                "type": "number"
              },
              "body": {
                "type": "json"
              }
            }
          }
        },
        {
          "content_type": "predefined_exercise",
          "schema": {
            "required": ["body"],
            "properties": {
              "exercise_type": {
                "type": "string",
                "enum": [
                  "Atividade prática",
                  "Calcule",
                  "Ouça o professor",
                  "Fique atento",
                  "Laboratório de informática",
                  "Vamos pesquisar",
                  "Música",
                  "Para saber mais",
                  "Recitação numérica",
                  "Roda de conversa",
                  "Sala de leitura",
                  "Tome nota"
                ]
              },
              "body": {
                "type": "string"
              },
              "icon_url": {
                "type": "string"
              }
            }
          }
        },
        {
          "content_type": "long_text",
          "schema": {
            "required": ["title", "body"],
            "properties": {
              "title": {
                "type": "string"
              },
              "body": {
                "type": "json"
              }
            }
          }
        },
        {
          "content_type": "gallery",
          "schema": {
            "properties": {
              "subtitle": {
                "type": "string"
              },
              "file": {
                "type": "file"
              }
            }
          }
        },
        {
          "content_type": "free_text",
          "schema": {
            "required": ["body"],
            "properties": {
              "body": {
                "type": "json"
              }
            }
          }
        },
        {
          "content_type": "open_text",
          "schema": {
            "required": ["title", "body"],
            "properties": {
              "title": {
                "type": "string"
              },
              "body": {
                "type": "json"
              }
            }
          }
        },
        {
          "content_type": "bullet",
          "schema": {
            "required": ["title", "body"],
            "properties": {
              "title": {
                "type": "string"
              },
              "body": {
                "type": "json"
              }
            }
          }
        },
        {
          "content_type": "survey_question",
          "schema": {
            "required": ["title", "body", "have_rating", "have_comment", "required_rating", "required_comment"],
            "properties": {
              "title": {
                "type": "string"
              },
              "body": {
                "type": "string"
              },
              "have_rating": {
                "type": "boolean"
              },
              "have_comment": {
                "type": "boolean"
              },
              "required_rating": {
                "type": "boolean"
              },
              "required_comment": {
                "type": "boolean"
              }
            }
          }
        }
      ].each do |attributes|
        cb = ContentBlock.find_or_create_by(content_type: attributes[:content_type])
        schema = attributes[:schema]
        cb.json_schema = schema.to_json
        puts "#{attributes[:content_type]} updated!" if cb.save
      end
    end

    desc "Create or Update Permitted Action"
    task create_or_update_permitted_actions: :environment do
      [
        { name: 'Atividades', class_name: 'Activity' },
        { name: 'Blocos de conteúdo das Atividades', class_name: 'ActivityContentBlock' },
        { name: 'Sequências de Atividades', class_name: 'ActivitySequence' },
        { name: 'Cadernos de Respostas', class_name: 'AnswerBook' },
        { name: 'Eixos', class_name: 'Axis' },
        { name: 'Blocos de conteúdo dos Desafios', class_name: 'ChallengeContentBlock' },
        { name: 'Desafios', class_name: 'Challenge' },
        { name: 'Componentes Curriculares', class_name: 'CurricularComponent' },
        { name: 'Matriz dos Saberes', class_name: 'KnowledgeMatrix' },
        { name: 'Objetivos de Aprendizagem', class_name: 'LearningObjective' },
        { name: 'Metodologias', class_name: 'Methodology' },
        { name: 'Parceiros', class_name: 'Partner' },
        { name: 'Consultas à Rede', class_name: 'PublicConsultation' },
        { name: 'Avaliações', class_name: 'Rating' },
        { name: 'Resultados', class_name: 'Result' },
        { name: 'Roteiros', class_name: 'Roadmap' },
        { name: 'Segmentos', class_name: 'Segment' },
        { name: 'Etapas', class_name: 'Stage' },
        { name: 'Blocos de conteúdo dos Formulários de Pesquisa', class_name: 'SurveyFormContentBlock' },
        { name: 'Formulários da Pesquisa', class_name: 'SurveyForm' },
        { name: 'Objetivos de Desenvolvimento Sustentável', class_name: 'SustainableDevelopmentGoal' },
        { name: 'Usuários', class_name: 'User' },
        { name: 'Anos', class_name: 'Year' },
        { name: 'Protanismo Estudantil', class_name: 'StudentProtagonism'}
      ].each { |action| PermittedAction.find_or_create_by(class_name: action[:class_name], name: action[:name]) }
    end

    desc "Add permission to admin users"
    task add_admin_permissions: :environment do
      pa = PermittedAction.all
      u = User.where(admin: true)
      u.each do |user|
        user.permitted_actions = pa
        user.save!
      end
    end
  end
end
