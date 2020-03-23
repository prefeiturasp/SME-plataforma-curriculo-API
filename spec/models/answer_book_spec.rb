require 'rails_helper'

RSpec.describe AnswerBook, type: :model do
  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to have_db_column(:cover_image).of_type(:string) }
  it { is_expected.to have_db_column(:book_file).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:cover_image) }
  it { is_expected.to validate_presence_of(:book_file) }
  it { is_expected.to belong_to(:curricular_component) }
end
