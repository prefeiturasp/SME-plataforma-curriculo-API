class Comment < ApplicationRecord
  belongs_to :teacher
  belongs_to :project
end
