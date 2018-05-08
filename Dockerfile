FROM ubuntu:18.04

#Set the timezone
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update -qq && apt-get install -y tzdata

# Install dependencies
RUN apt-get update -y
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs ruby libffi-dev libxml2 patch ruby-dev zlib1g-dev liblzma-dev

# Configuring main directory
RUN mkdir -p /mnt/data/patio-digital
WORKDIR /mnt/data/patio-digital

# Setting env up
ENV RAILS_ENV='staging'
ENV RAKE_ENV='staging'

# Adding gems
COPY Gemfile /mnt/data/patio-digital/Gemfile
COPY Gemfile.lock /mnt/data/patio-digital/Gemfile.lock

RUN gem install bundler
RUN bundle install --jobs 20 --retry 5 --without development test

# Adding project files
COPY . /mnt/data/patio-digital
RUN bundle exec rake assets:precompile
EXPOSE 80
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
