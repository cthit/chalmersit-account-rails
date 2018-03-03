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
mariadb-server \
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
COPY Gemfile.lock /packagefiles/Gemfile.lock

# Add and change to unprivileged user
RUN groupadd accounts -r &&\
useradd -m -g accounts accounts &&\
usermod -aG redis accounts &&\
usermod -aG www-data accounts &&\
usermod -aG sudo accounts &&\
usermod -aG bin accounts &&\
chown -R accounts:accounts /var/lib/gems &&\
chown -R accounts:accounts /usr/local/bin &&\
chown -R accounts:accounts /packagefiles
USER accounts:accounts
WORKDIR /packagefiles

# Install from Gemfile
RUN bundle install

WORKDIR /app

CMD bundle exec rake db:create db:migrate \
&& bundle exec rake rails:update:bin \
# Removes server.pid to make the container realize that we restarted it
&& rm tmp/pids/server.pid \ 
&& rails s -p 3000 -b '0.0.0.0'