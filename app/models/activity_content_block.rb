class ActivityContentBlock < ApplicationRecord
  include ConvertImageConcern
  include ContentBlockConcern

  belongs_to :activity
end
