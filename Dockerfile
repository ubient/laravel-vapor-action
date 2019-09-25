FROM composer:latest

LABEL repository="https://github.com/ubient/laravel-vapor-action"
LABEL homepage="https://github.com/ubient/laravel-vapor-action"
LABEL maintainer="Claudio Dekker <claudio@ubient.net>"

LABEL com.github.actions.name="Laravel Vapor"
LABEL com.github.actions.description="Run Laravel Vapor commands directly from Github Actions"
LABEL com.github.actions.icon="upload-cloud"
LABEL com.github.actions.color="blue"

# Install Vapor + Prestissimo (parallel/quicker composer install)
RUN set -xe && \
        composer global require hirak/prestissimo && \
        composer global require laravel/vapor-cli && \
        composer clear-cache

# Install Node.js (needed for Vapor's NPM Build)
RUN apk add --update nodejs npm

# Prepare out Entrypoint (used to run Vapor commands)
COPY vapor-entrypoint /usr/local/bin/vapor-entrypoint

ENTRYPOINT ["/usr/local/bin/vapor-entrypoint"]
