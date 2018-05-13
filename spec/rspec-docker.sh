#!/bin/bash
#
# Run rspec inside Docker

DOCKERFILE_TAG="makigas/makigas-rspec:latest"

export RAILS_ENV="test"
export DB_HOST="dbtest"
export DB_NAME="makigas"
export DB_USERNAME="makigas"
export DB_PASSWORD="makigas"

# Run with the context set to .. to locate all the application files.
# Still, set the file to the spec Dockerfile or things won't work.
docker build --rm -t "$DOCKERFILE_TAG" -f Dockerfile .. || exit 1

# Create a network to connect the two containers.
docker network create --driver bridge railsnet || exit 1

# Run PostgreSQL in a separate instance
docker run --rm -d --name $DB_HOST \
  -e POSTGRES_USER=$DB_USERNAME -e POSTGRES_PASSWORD=$DB_PASSWORD \
    --network railsnet postgres:alpine || exit 1

# Set up cleanup to remove additional containers on exit.
function cleanup() {
  docker stop $DB_HOST
  docker network rm railsnet
}
trap "cleanup" EXIT

# Then run the test image.
docker run --rm \
  -e RAILS_ENV -e DB_HOST -e DB_NAME -e DB_USERNAME -e DB_PASSWORD \
  -v "$PWD/../:/makigas" -v "/makigas/tmp" -v "/makigas/node_modules" \
  --network railsnet $DOCKERFILE_TAG "$@"

# Status code
RAILS_CODE=$?
exit $RAILS_CODE
