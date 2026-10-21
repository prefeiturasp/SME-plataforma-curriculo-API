FROM ruby:2.6.10-buster 

RUN mkdir -p /app
WORKDIR /app 

RUN apt-get update -y

RUN apt-get install -y \
    build-essential \
    git \
    imagemagick \
    libxml2-dev \
    libxslt-dev \
    libpq-dev \
    tzdata \
    libyaml-dev \
    zlib1g-dev

RUN apt install nodejs npm -y

RUN npm install -g yarn
RUN yarn install 

COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v 2.4.22
RUN bundle install --jobs 20 --retry 5 

COPY . ./
EXPOSE 8666

CMD bundle exec rake db:migrate && bundle exec puma -v -C config/puma.rb
