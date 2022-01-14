#!/bin/bash -e

vagrant ssh -c "cd /vagrant && bundle exec puma -p 3000"
