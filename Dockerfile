FROM ruby:2.5.1-alpine

ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8

RUN mkdir -p /app 
WORKDIR /app

RUN apk update && apk upgrade

RUN apk add -U --no-cache \
			build-base \
			git \
			imagemagick \
			libxml2-dev \
			libxslt-dev \
			nodejs \
			postgresql-dev \
			tzdata \
			yaml-dev \
			yarn \
			zlib-dev

RUN npm install -g yarn
RUN yarn install

COPY Gemfile Gemfile.lock ./

RUN gem install bundler
RUN bundle install --jobs 20 --retry 5

COPY . ./
EXPOSE 8666

COPY docker-entrypoint.sh ./
RUN ["chmod", "+x", "docker-entrypoint.sh"]
ENTRYPOINT ["./docker-entrypoint.sh"]

CMD bundle exec puma -v -C config/puma.rb