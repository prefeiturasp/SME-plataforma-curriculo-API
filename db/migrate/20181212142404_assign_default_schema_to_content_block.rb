class AssignDefaultSchemaToContentBlock < ActiveRecord::Migration[5.2]
  def up
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
      cb.save
    end
  end
end
