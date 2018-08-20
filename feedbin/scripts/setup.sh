#!/usr/bin/env bash

umask 002

cd /srv/apps/feedbin/current

# Unicorn server
echo 'web: bundle exec unicorn -c config/unicorn.rb' >> Procfile

sed -E -i config/unicorn.rb \
    -e '/^ *user .+/d' \
    -e 's/^ *listen .+/listen 3000/' \
    -e 's;^ *stderr_path .+;stderr_path "/dev/stderr";' \
    -e 's;^ *stdout_path .+;stdout_path "/dev/stdout";'

# CarrierWave uses :file instead of AWS S3
head -n -1 config/initializers/carrierwave.rb > __tmp

cat <<EOF >> __tmp
else
  require 'carrierwave/storage/fog'

  CarrierWave.configure do |config|
    config.storage = :file
    config.root = "#{Rails.root}/tmp"
    config.cache_dir = "#{Rails.root}/tmp/images"
  end
end
EOF

mv __tmp config/initializers/carrierwave.rb

# Pre-compile assets
LC_ALL=en_US.UTF-8 RAILS_ENV=production \
      DATABASE_URL=postgres://postgres:postgres@127.0.0.1/feedbin \
      MEMCACHED_HOSTS=127.0.0.1:11211 \
      SECRET_KEY_BASE=secret \
      bundle exec rake assets:precompile

# Fix permissions
mkdir -p /srv/apps/feedbin/shared/tmp/pids
chmod g=u Gemfile.lock config config/unicorn.rb /srv/apps/feedbin/shared/
