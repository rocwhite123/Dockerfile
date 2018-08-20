FROM ruby:2.3

ENV GEM_HOME=/srv/vendor/bundle BUNDLE_PATH=/srv/vendor/bundle \
    BUNDLE_APP_CONFIG=/srv/vendor/bundle BUNDLE_SILENCE_ROOT_WARNING=1

RUN apt-get -qy update; \
    apt-get -y install --no-install-recommends libidn11-dev postgresql-client; \
    apt-get -qy clean; \
    mkdir -p /srv/apps/feedbin/current; \
    chmod -R g=u /etc/passwd /srv

WORKDIR /srv/apps/feedbin/current

COPY ["feedbin/Gemfile", "feedbin/Gemfile.lock", "/srv/apps/feedbin/current/"]
RUN umask 002 && \
    LC_ALL=en_US.UTF-8 RAILS_ENV=production bundle install --without test development --path /srv/vendor/bundle -j 4

COPY feedbin/ /srv/apps/feedbin/current/

COPY scripts/setup.sh /srv/scripts/
RUN /srv/scripts/setup.sh

COPY ["scripts/feedbin.sh", "scripts/setup_env.sh", "/srv/scripts/"]
CMD ["/srv/scripts/feedbin.sh"]

EXPOSE 3000
USER 1001