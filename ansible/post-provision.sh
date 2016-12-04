#!/bin/bash

gem install bundler
cd /vagrant
bundle install

IP=$(ip route get 8.8.8.8 | awk '{print $3; exit}')

DATABASE_URL=postgres://postgres:mysecretpassword@$IP/charlie bundle exec rake db:migrate
REDIS_HOST=$IP DATABASE_URL=postgres://postgres:mysecretpassword@$IP/charlie bundle exec rackup -s Puma --host 0.0.0.0 2>&1 |logger -t Puma &
