FROM ruby:2.4

LABEL maintainer="robcataneo@gmail.com"

# allow apt to work with https-based sources
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \ 
    apt-transport-https

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -qq -y build-essential nodejs yarn

# Install packages
# RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends | nodejs | yarn

COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app

ENV BUNDLE_PATH /gems

RUN bundle install
# CMD export PATH=$PATH:$BUNDLE_PATH

COPY . /usr/src/app/

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
