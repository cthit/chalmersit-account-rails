#Dockerfile for Beta-accounts
FROM debian:buster
MAINTAINER digIT <digit@chalmers.it>


# Create directories
RUN mkdir packagefiles && mkdir app


# Install prerequisites
RUN apt-get update && apt-get install -y \
## Packages
nodejs \
rbenv \
vim \
#mariadb-server \
mariadb-client \
default-libmysqlclient-dev \
curl \
imagemagick \
git \
ruby-dev \
libkrb5-dev \
redis-server

# Install bundler
RUN gem install bundler

# Copy Gemfile into the container
COPY Gemfile /packagefiles/Gemfile
WORKDIR /packagefiles

# Install from Gemfile
RUN bundle
# Add and change to unprivileged user
RUN groupadd accounts -r && useradd -m -g accounts accounts
USER accounts:accounts

CMD cd /app && bundle exec rake db:create db:migrate && rails s -p 3000 -b '0.0.0.0'