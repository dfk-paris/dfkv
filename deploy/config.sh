#!/bin/bash

export REPO="."
export HOST="app@10.10.1.33"
export SSH_KEY="$HOME/.ssh/id_rsa"
export PORT="22"
export RUBY_VERSION="2.7.5"
export KEEP=5

function ng {
  export DEPLOY_TO="/var/storage/host/dfkv-ng"
  export COMMIT="ng"
}

function production {
  export DEPLOY_TO="/var/storage/host/dfkv"
  export COMMIT="master"
  export RUBY_VERSION="3.3.6"
}
