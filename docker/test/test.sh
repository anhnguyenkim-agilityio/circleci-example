#!/usr/bin/env bash

set -ev

SCRIPT_DIR=`dirname "$0"`
SRC_DIR=$(cd $SCRIPT_DIR/../..; pwd)

if [[ -z $(docker images | grep test-container) ]] ; then
    echo "Building test container"
    docker build -f $SCRIPT_DIR/Dockerfile -t test-container $SRC_DIR > /dev/null
fi

echo "Testing $1"

docker run \
    --rm \
    --name test \
    --net=host \
    -e POSTGRES_DB='testdb' \
    -e POSTGRES_USER='testuser' \
    -e POSTGRES_PASSWORD='testpwd' \
    -e POSTGRES_HOST='localhost' \
    -e POSTGRES_PORT='5432' \
    test-container \
    sh -c "bin/dj-test.sh $@"