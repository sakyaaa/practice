# Base image
ARG RUBY_VERSION=3.3.5
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Set working directory
WORKDIR /app

# Install essential development tools and dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    node-gyp \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV RAILS_ENV=development
ENV BUNDLE_PATH=/bundle
ENV PATH="/app/bin:${PATH}"

# Build stage
FROM base AS build

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems with better caching
RUN bundle config set --local path '/bundle' && \
    bundle check || bundle install --jobs 4

# Copy the rest of the application
COPY . .
