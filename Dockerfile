# Dockerfile
# Use ruby image to build our own image
FROM ruby:2.7.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm ghostscript

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app
# We copy these files from our current application to the /app container
COPY Gemfile Gemfile.lock ./
RUN bundle check || bundle install

COPY . .

RUN node -v
RUN npm -v

RUN npm install -g yarn
RUN yarn install --check-files

RUN SECRET_KEY_BASE=1 RAILS_ENV=production rake assets:precompile
CMD ["rails", "server", "-b", "0.0.0.0"]

