
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

| Canal de comunicação                                                                    | Objetivos                                                                                                                            |
| --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| [Issues do Github](https://github.com/prefeiturasp/SME-plataforma-curriculo-API/issues) | - Sugestão de novas funcionalidades<br> - Reportar bugs<br> - Discussões técnicas                                                    |
| [Telegram](https://t.me/patiodigital )                                                  | - Comunicar novidades sobre os projetos<br> - Movimentar a comunidade<br>  - Falar tópicos que **não** demandem discussões profundas |

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

É necessário definir paramêtros de banco de dados no ambiente de desenvolvimento.
- Copie `config/database.example.yml` para `config/database.yml`
```bash
$ cp config/database.example.yml config/database.yml
```

- Copie `config/secrets.example.yml` para `config/secrets.yml`
```bash
$ cp config/secrets.example.yml config/secrets.yml
```

- Copie `.docker-env-dev.example` para `.docker-env-dev` e defina as variáveis de ambiente, certificando que todas estão definidas corretamente.
```bash
$ cp .docker-env-dev.example .docker-env-dev
```

Execute o docker build para criar o banco de dados e criar o seu aplicativo:

```bash
$ docker-compose build app_development
```

Depois que todas as dependências estiverem instaladas e o projeto foi criado, execute o aplicativo:

```bash
$ docker-compose up app_development
```

Após a configuração, você pode executar o aplicativo e as dependências usando [docker-compose]:

```bash
$ docker-compose up app_development
```

Seu host do docker está sendo executado em `localhost:3000`

### Producão

Primeiro, você precisará configurar as variáveis de ambiente no seu docker-compose.
Certifique-se que todas as variáveis abaixo foram definidas.

- Variáveis de ambiente do aplicativo rails (ambiente de produção):
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

Deploy com capistrano
---------------------------

Use o Capistrano para deploy, mas configure alguns arquivos necessários antes:

* Crie uma nginx.conf em `<shared_path>/docker/web/nginx.conf`. Na mesma pasta há um arquivo de amostra.

* Crie um arquivo docker-compose em `<shared_path>/docker-compose.yml`. Pegue o arquivo docker-compose.yml no aplicativo raiz e crie suas variáveis de ambiente.
  - Variaveis de ambiente do Rails (ambiente de produção):
```
      PLATAFORMA_USERNAME
      PLATAFORMA_DATABASE
      PLATAFORMA_PASSWORD
      PLATAFORMA_HOST
```
  - banco de dados:
```
      POSTGRES_USER
      POSTGRES_PASSWORD
      POSTGRES_DB
```

* Na pasta compartilhada `<shared_path>/config`, crie os arquivos de configuração necessários para executar o rails (master.key, database.yml, storage.yml, secrets.yml ).

* Instale o [Docker](https://www.docker.com/products/docker) e [`docker-compose`](https://docs.docker.com/compose/overview/) no servidor que irá executar o deploy.

Execute o `cap <environment> deploy:check` para verificar se todas as dependências foram criadas.

Se todos os arquivos de configuração foram criados, execute o comando acima para deploy da aplicação, crie o docker build, e carregue o container.

`$ cap <environment> deploy `

Se for a primeira execução, execute os comandos abaixo para criar e executar as migrações do banco de dados.

`$ cap <environment> docker:setup_db`
  `$ cap <environment> docker:migrate`

Ferramentas
---------------------------

* Execute o seguinte teste

```ruby
    $ rspec
```

* Execute o analisador de código estático do ruby

Este projeto usa o rubocop gem para o analisador de código estático do ruby executar a análise

```console
    $ rubocop
```
---

Baseado no Readme do [i-educar](https://github.com/portabilis/i-educar)
