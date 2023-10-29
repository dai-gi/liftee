FROM ruby:3.0.1

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /liftee-backend
COPY Gemfile /liftee-backend/Gemfile
COPY Gemfile.lock /liftee-backend/Gemfile.lock
RUN bundle install
COPY . /liftee-backend

CMD ["rails", "server", "-b", "0.0.0.0"]
