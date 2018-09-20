
[![Maintainability](https://api.codeclimate.com/v1/badges/ba5de8ada9b8fffe5bc2/maintainability)](https://codeclimate.com/github/prefeiturasp/SME-plataforma-curriculo-API/maintainability)

# Pátio Digital

_“Recurso público retorna ao público”._

Nós somos o **pátio digital**, uma iniciativa da Secretaria Municipal de Educação de São Paulo que, por meio do fortalecimento da transparência, da participação social e do desenvolvimento de novas tecnologias, aproxima diferentes grupos da sociedade civil por um objetivo maior: a melhoria da educação na cidade de São Paulo. 

# Plataforma Currículo Digital

## Conteúdo

1. [Sobre o curriculo digital](#sobre-o-curriculo-digital)
2. [Comunicação](#comunicação)
3. [Como contribuir](#como-contribuir)
4. [Instalação](#instalação)

## Sobre o Curriculo Digital

Para que docentes e comunidade tenham acesso as orientações didáticas e materiais de apoio propostos nas escolas Municipais da Cidade de São Paulo atraves de uma platafoma informatizada, a Secretária Municipal de educação, por meio da iniciativa de governo aberto [Pátio Digital](http://patiodigital.prefeitura.sp.gov.br/), está em processo de implantação digital do curriculo da cidade.


### Nossos outros repositórios

1. [Plataforma curriculo](https://github.com/prefeiturasp/SME-plataforma-curriculo-interface)
2. [Plataforma curriculo API](https://github.com/prefeiturasp/SME-plataforma-curriculo)

## Comunicação

| Canal de comunicação | Objetivos |
|----------------------|-----------|
| [Issues do Github](https://github.com/prefeiturasp/SME-plataforma-curriculo-API/issues) | - Sugestão de novas funcionalidades<br> - Reportar bugs<br> - Discussões técnicas |
| [Telegram](https://t.me/patiodigital ) | - Comunicar novidades sobre os projetos<br> - Movimentar a comunidade<br>  - Falar tópicos que **não** demandem discussões profundas |

Qualquer outro grupo de discussão não é reconhecido oficialmente.

## Como contribuir

Contribuições são **super bem vindas**! Se você tem vontade de construir o
curriculo digital conosco, veja o nosso [guia de contribuição](./CONTRIBUTING.md)
onde explicamos detalhadamente como trabalhamos e de que formas você pode nos
ajudar a alcançar nossos objetivos. Lembrando que todos devem seguir 
nosso [código de conduta](./CODEOFCONDUCT.md).

## Instalação

Dependências do sistema
-------------------

- CentOS 7
- Ruby 2.5.1
- Rails 5.2.0
- Rubygems
- Bundler (`gem install bundler`)
- PostgreSQL

Funcionamento do Docker
---------------------------

Este projeto vem equipado para ser executado dentro do Docker, mas isso requer algumas dependêcias locais. Para instruções de instalação e outras duvidas sobre o Docker acesse [here](https://www.docker.com/products/docker) e [`docker-compose`](https://docs.docker.com/compose/overview/).

### Desenvolvimento

É necessário definir paramêtros de banco de dados no ambiente de desenvolvimento
Is necessary define database and secrets parameters on development environment.
- Copie `config/database.yml.example` para `config/database.yml`
- Copie`config/secrets.yml.example` para `config/secrets.yml`
- Copie `.docker-env-dev.example` para `.docker-env-dev` e defina as variáveis de ambiente, certificando que todas estão definidas corretamente.

Execute o build do docker para criar o banco de dados e criar o seu aplicativo

`$ docker-compose build app_development`

Depois que todas as dependências estiverem instaladas e o projeto foi criado, execute o aplicativo

`$ docker-compose up app_development`

Após a configuração, você pode executar o aplicativo e as dependências usando [docker-compose]:

`$ docker-compose up app_development`

Seu host do docker está sendo executado em `localhost:3000` 

### Producão

Primeiro, você precisará configurar as variáveis de ambiente no seu docker-compose, 

On first you'll need set environment variables on your docker-compose, make sure that all environment variables have been defined below:

- Variáveis de ambiente do aplicativo rails (production environment):
```
    APPLICATION_ROOT_PATH
    PLATAFORMA_USERNAME
    PLATAFORMA_DATABASE
    PLATAFORMA_PASSWORD
    PLATAFORMA_HOST
```
- Banco de dados:
```
    POSTGRES_USER
    POSTGRES_PASSWORD
    POSTGRES_DB
```

Deploy with capistrano
---------------------------

Use Capistrano for deploy, there are some configuration files that are required. See the list below:

* Create a nginx.conf on `<shared_path>/docker/web/nginx.conf`. In the same folder there is a sample file.

* Create a docker-compose file on `<shared_path>/docker-compose.yml`. Get the docker-compose.yml file on root application and make your environment variables.
  - Rails application environment variables (production environment):
```
      PLATAFORMA_USERNAME
      PLATAFORMA_DATABASE
      PLATAFORMA_PASSWORD
      PLATAFORMA_HOST
```
  - Database:
```
      POSTGRES_USER
      POSTGRES_PASSWORD
      POSTGRES_DB
```

* In the shared folder `<shared_path>/config`, create the configuration files needed to run rails (master.key, database.yml, storage.yml, secrets.yml ).

* Install the [Docker](https://www.docker.com/products/docker) and [`docker-compose`](https://docs.docker.com/compose/overview/) on the server that deploy will be performed.

Run the `cap <environment> deploy:check` command to verify that all dependencies have been created.

If all the configuration files were created, run the command above to deploy the application, create the docker build, and upload the container.

`$ cap <environment> deploy `

If it is the first run run the commands below to create and run the database migrations.

  `$ cap <environment> docker:setup_db`
  `$ cap <environment> docker:migrate`

Tools
---------------------------

* Run the test suite

```ruby
    $ rspec
```

*  Run the ruby static code analyzer

This project uses rubocop gem to ruby static code analyzer, to run the analysis

```console
    $ rubocop
```


---

Baseado no Readme do [i-educar](https://github.com/portabilis/i-educar)
