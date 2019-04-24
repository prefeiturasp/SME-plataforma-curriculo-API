namespace :db do
  namespace :seed do
    desc "Create or Update Teachers"
    task create_or_update_teachers: :environment do
      [
        'prof@jurema.la', 'prof1@jurema.la', 'prof2@jurema.la', 'prof3@jurema.la'
      ].each do |email|
        user = FactoryBot.build :user

        user.email = email
        user.password = "qwe123"

        User.where(email: email).first_or_create.update user.as_json.reject{|k,v| v.blank?}

        if Teacher.joins(:user).where(users: { email: email }).blank?
          teacher = Teacher.create!(
            user:     User.where(email: email).first,
            nickname: Faker::Internet.user_name(7..15),
            name:     Faker::Name.unique.name
          )

          teacher.avatar.attach(
            io:           File.open(Rails.root.join('spec', 'factories', 'images', 'ruby.png')),
            filename:     'ruby.png',
            content_type: 'image/png'
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

        if LearningObjective.joins(:curricular_component).where(curricular_components: { slug: cc.slug }).blank?
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
    end



    desc "Create or Update Challenges"
    task create_or_update_challenges: :environment do



=begin
  has_and_belongs_to_many :learning_objectives
  has_and_belongs_to_many :curricular_components
  has_and_belongs_to_many :knowledge_matrices

  has_many :axes, through: :learning_objectives
  has_many :challenge_content_blocks, dependent: :destroy

  enum category: { project: 0, make_and_remake: 1, games_and_investigation: 2 }
  enum status: { draft: 0, published: 1 }

  validates :title, presence: true, uniqueness: true
  validates :finish_at, presence: true
  validates :category, presence: true
  validates :learning_objectives, presence: true
  validates :slug, presence: true, uniqueness: true
=end



    end

    desc "Create or Update Results"
    task create_or_update_results: :environment do
      [
        {

        }, {

        }
      ].each do |attributes|

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
        }
      ].each do |attributes|
        cb = ContentBlock.find_or_create_by(content_type: attributes[:content_type])
        schema = attributes[:schema]
        cb.json_schema = schema.to_json
        puts "#{attributes[:content_type]} updated!" if cb.save
      end
    end
  end
end
