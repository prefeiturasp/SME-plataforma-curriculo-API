module YearsEnum
  extend ActiveSupport::Concern

  included do
    enum year: { first: 1, second: 2, third: 3 }, _suffix: true
  end
end
