FROM ruby:2.4.2
MAINTAINER Yusuke Izumi <yusuke@gmail.com>

ENV APP_HOME /home/app
ENV BUNDLE_PATH /bundle

# Libraries
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN apt-get install -y apt-utils
RUN apt-get install -y libssl-dev
RUN apt-get install -y mysql-client libmysqlclient-dev
RUN apt-get install -y apt-transport-https

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# Rails Preparation
RUN mkdir -p $APP_HOME 
WORKDIR $APP_HOME
RUN gem install bundler
COPY Gemfile* $APP_HOME/
RUN bundle install --jobs 5 --retry 5 --without development test
ADD . $APP_HOME
ENV RAILS_ENV production
RUN yarn run install-frontend
RUN bundle exec rake tmp:create
RUN bundle exec rake assets:precompile
COPY ./.env.production $APP_HOME/

EXPOSE 3000

CMD ./start-server.sh
