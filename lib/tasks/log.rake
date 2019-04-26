desc 'Make any task with sql queries output to stdout'
task log: :environment do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
