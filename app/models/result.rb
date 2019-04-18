class Result < ApplicationRecord
  has_many :links, dependent: :destroy
end
