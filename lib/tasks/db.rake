namespace :db do
  namespace :seed do
    desc 'Create Fake name for users'
    task create_fake_name_for_users: :environment do
      User.all.each do |user|
        user.update(name: Faker::Name.name)
      end
    end
  end
end
