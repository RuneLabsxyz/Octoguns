set -euo pipefail
pushd $(dirname "$0")/..

export WORLD_ADDRESS=$(cat ./manifest_dev.json | jq -r '.world.address')

torii --world $WORLD_ADDRESS --allowed-origins "*"
