# syntax=docker/dockerfile:1
FROM ruby:3.4.7-slim

# Diretório principal do app
WORKDIR /app

# Instala dependências básicas para dev
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    libvips \
    libyaml-dev \
    libmariadb-dev \
    nodejs \
    git \
    curl \
    bash && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Copia o entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Copia o Gemfile primeiro (para cache de bundle)
COPY Gemfile Gemfile.lock ./
RUN bundle install && bundle config set --local path 'vendor/bundle'

# Copia todo o código do app
COPY . .

# Usa o entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]

# Executa servidor padrão
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
