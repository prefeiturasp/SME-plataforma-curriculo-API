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
WORKDIR /mnt/data/patio-digital

# Setting env up
ENV RAILS_ENV='staging'
ENV RAKE_ENV='staging'

# Adding gems
COPY Gemfile /mnt/data/patio-digital/Gemfile
COPY Gemfile.lock /mnt/data/patio-digital/Gemfile.lock

# Install bundle and Gems
RUN gem install bundler
RUN bundle install --jobs 20 --retry 5 --without development test

# Adding project files
COPY . /mnt/data/patio-digital

EXPOSE 80
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
