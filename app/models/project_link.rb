class ProjectLink < ApplicationRecord
  belongs_to :project
  validates :link, presence: true
end
