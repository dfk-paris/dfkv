#!/bin/bash -e

if ! which npm > /dev/null ; then
  echo "npm not available, can't continue"
fi

function deploy {
  setup
  deploy_code
  cleanup

  # frontend
  npm run build

  # app
  remote "ln -sfn $SHARED_PATH/env $CURRENT_PATH/.env.local"
  remote "echo $RUBY_VERSION > $CURRENT_PATH/.ruby-version"
  within_do $CURRENT_PATH "bundle --clean --quiet --without test development --path $SHARED_PATH/bundle.$RUBY_VERSION"
  remote "mkdir $CURRENT_PATH/public"
  remote "mkdir $CURRENT_PATH/tmp"
  upload "frontend/public/*" "$CURRENT_PATH/public/"
  remote "touch $CURRENT_PATH/tmp/restart.txt"
  within_do $CURRENT_PATH "bundle exec bin/index"

  finalize
}

function configure {
  source deploy/config.sh
  $1
  source deploy/lib.sh
}

configure
deploy