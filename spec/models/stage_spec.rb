require 'rails_helper'

RSpec.describe Stage, type: :model do
  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to belong_to(:segment) }
end
