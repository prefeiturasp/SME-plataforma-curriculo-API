class Content < ApplicationRecord
  include ConvertImageConcern
  include ContentBlockConcern

  #belongs_to :challenge
  belongs_to :contentable, polymorphic: true
end
