FROM centos:7

RUN yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl

RUN yum install -y postgresql-devel
WORKDIR /tmp

ADD https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.gz /tmp
RUN tar -xzf ruby-2.5.1.tar.gz && rm ruby-2.5.1.tar.gz

WORKDIR /tmp/ruby-2.5.1
RUN ./configure && make && make install

# Configuring main directory
RUN mkdir -p /mnt/data/patio-digital

ENV APP_ROOT /mnt/data/patio-digital

WORKDIR $APP_ROOT

# Setting env up
ENV RAILS_ENV='staging'
ENV RAKE_ENV='staging'
ENV PUMA_PORT=3000

# Adding gems
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock

# Install bundle and Gems
RUN gem install bundler
RUN bundle install --jobs 20 --retry 5 --without development test

COPY ./docker-compose.yml /tmp/docker-compose-template.yml

RUN envsubst '$APP_ROOT' < "/tmp/docker-compose-template.yml" > $APP_ROOT

# Adding project files
COPY . $APP_ROOT

# Add puma directories
RUN mkdir -p shared/pids shared/sockets shared/log

EXPOSE 3000

# Assets precompile
# RUN if [ $RAILS_ENV = 'staging' ]; then bundle exec rake assets:precompile --trace; fi

# Expose assets for web container
VOLUME $APP_ROOT/public

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

