# Dockerfile
# Use ruby image to build our own image
FROM ruby:2.7


# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app
# We copy these files from our current application to the /app container
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
CMD ["rails", "server", "-b", "0.0.0.0"]

