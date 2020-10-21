require 'rails_helper'

RSpec.describe Project, type: :model do
  it { is_expected.to have_db_column(:old_id).of_type(:string) }
  it { is_expected.to have_db_column(:title).of_type(:string) }
  it { is_expected.to have_db_column(:school).of_type(:string) }
  it { is_expected.to have_db_column(:dre).of_type(:string) }
  it { is_expected.to have_db_column(:description).of_type(:string) }
  it { is_expected.to have_db_column(:summary).of_type(:string) }
  it { is_expected.to have_db_column(:owners).of_type(:string) }
  it { is_expected.to have_and_belong_to_many(:areas) }
  it { is_expected.to have_and_belong_to_many(:advisors) }
  it { is_expected.to have_and_belong_to_many(:curriculum_subjects) }
  it { is_expected.to have_and_belong_to_many(:tags) }
  it { is_expected.to have_and_belong_to_many(:participants) }
end
