if Rails.env.development?
  User.create!(
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password',
    superadmin: true
  )
end

ActivityType.create(
  [
    { name: 'Exterior' },
    { name: 'Interior' }
  ]
)

CurricularComponent.create(
  [
    { name: 'Arte' },
    { name: 'Ciências Naturais' },
    { name: 'Educação Física' },
    { name: 'Geografia' },
    { name: 'História' },
    { name: 'Língua Portuguesa' },
    { name: 'Língua Inglesa' },
    { name: 'Matemática' },
    { name: 'Tecnologias de Aprendizagem' }
  ]
)
