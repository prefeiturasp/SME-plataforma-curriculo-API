if Rails.env.development?
  User.create!(
    email: 'admin@jurema.la',
    password: 'senhasegura',
    password_confirmation: 'senhasegura',
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
