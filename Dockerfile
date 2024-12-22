FROM ruby:2.7.1-alpine3.12 AS builder

WORKDIR /app
COPY . .
RUN apk add --no-cache build-base libxml2-dev libxslt-dev postgresql-dev nodejs npm yarn git python2 python3 tzdata shared-mime-info \
 && bundle update mimemagic \ 
 && bundle install --without test \
 && yarn install --production \
 && bundle exec rake assets:precompile \
 && rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete \
 && rm -rf ./tmp/cache .browserlistrc babel.config.js node_modules package.json postcss.config.js tsconfig.json yarn.lock

FROM ruby:2.7.1-alpine3.12
COPY --from=builder /app /app
COPY --from=builder /usr/local/bundle /usr/local/bundle
WORKDIR /app
RUN apk add --no-cache tzdata postgresql-client xz-libs wget \
 && addgroup -S fiber && adduser -S fiber -G fiber \
 && chown -R fiber:fiber .
ENV RAILS_ENV=production
EXPOSE 3000
USER fiber
CMD ["sh", "-c", "bundle exec rake db:migrate && bundle exec rails server -b 0.0.0.0"]
