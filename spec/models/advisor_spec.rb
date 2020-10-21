require 'rails_helper'

RSpec.describe Advisor, type: :model do
  it { is_expected.to have_db_column(:old_id).of_type(:string) }
  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to have_and_belong_to_many(:projects) }
end
