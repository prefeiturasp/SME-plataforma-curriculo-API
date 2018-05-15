user = User.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  superadmin: true) if Rails.env.development?

ActivityType.create(
  [
    { name: ' Exterior' },
    { name: 'Interior' }
  ])
