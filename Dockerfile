FROM ruby:3.3.5

# Set the working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs npm wkhtmltopdf

# Install Yarn
RUN npm install --global yarn

# Copy Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install Ruby gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose port 3000 to the outside world
EXPOSE 3000

# Set the entrypoint for the container
CMD ["rails", "server", "-b", "0.0.0.0"]
