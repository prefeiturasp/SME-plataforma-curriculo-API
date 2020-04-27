require 'rails_helper'

RSpec.describe AnswerBook, type: :model do
  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to validate_presence_of(:name) }
end
