FROM ruby:2.4.2
MAINTAINER Yusuke Izumi <yusuke@gmail.com>

ENV APP_HOME /home/app
ENV BUNDLE_PATH /bundle

# Libraries
RUN apt-get update -qq
RUN apt-get install -y build-essential nodejs
RUN apt-get install -y libssl-dev
RUN apt-get install -y mysql-client libmysqlclient-dev

# Rails Preparation
RUN mkdir -p $APP_HOME 
WORKDIR $APP_HOME
RUN gem install bundler
COPY Gemfile* $APP_HOME/
RUN bundle install --jobs 5 --retry 5 --without development test
ADD . $APP_HOME

# Starting App
ENV RAILS_ENV production
RUN bundle exec rake tmp:create
RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD bundle exec puma -w 3 --preload
