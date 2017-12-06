#Dockerfile for Beta-accounts
FROM debian:buster
MAINTAINER digIT <digit@chalmers.it>

# Setup unprivileged user
#RUN mkdir /app && mkdir /output && \
#groupadd -r user && useradd -m -g accounts accounts

# Install prerequisites
RUN apt-get update && apt-get install -y \
# Packages
nodejs \
#ruby_build \
rbenv \
vim \
mariadb-server \
mariadb-client \
default-libmysqlclient-dev \
curl \
imagemagick \
git \
ruby-dev \
libkrb5-dev \
redis-server
#krb5-config \
#krb5-clients \
#krb5-user


# Install bundler
RUN gem install bundler

# Copy Source files
RUN mkdir /app
COPY . /app


RUN groupadd accounts -r && useradd -m -g accounts accounts

#RUN gem install nokogiri -v '1.6.6.2'


#USER accounts:accounts


WORKDIR /app

# Install from Gemfile
RUN bundle


EXPOSE 3000
# Change ownership and su unprivileged user
#RUN chown -R meteor:meteor /app && chown -R meteor /output
#USER accounts:accounts
CMD bundle exec rake db:create db:migrate && rails s -p 3000 -b '0.0.0.0'
