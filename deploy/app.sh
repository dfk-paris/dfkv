#!/bin/bash -e

if ! which npm > /dev/null ; then
  echo "npm not available, can't continue"

  local "npm install"
  local "npm run build"

  
fi

function deploy {
  setup
  deploy_code
  cleanup

  # database
  mysqldump -u root -proot dfkv | gzip -c | ssh root@192.168.30.212 "gunzip -c | mysql -u root dfkv"

  # app
  remote "echo 2.4.2 > $CURRENT_PATH/.ruby-version"
  within_do $CURRENT_PATH "bundle --clean --quiet --deployment --without test development --path $SHARED_PATH/bundle"
  remote "mkdir $CURRENT_PATH/public"
  upload "public/app.*" "$CURRENT_PATH/public/"
  remote "touch $CURRENT_PATH/tmp/restart.txt"

  finalize
}

function configure {
  source deploy/config.sh
  $1
  source deploy/lib.sh
}

configure
deploy