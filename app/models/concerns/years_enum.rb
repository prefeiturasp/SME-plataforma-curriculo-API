module YearsEnum
  extend ActiveSupport::Concern

  included do
    enum year: { first: 1,
                 second: 2,
                 third: 3,
                 fourth: 4,
                 fifth: 5,
                 sixth: 6,
                 seventh: 7,
                 eighth: 8,
                 nineth: 9 }, _suffix: true
  end
end
