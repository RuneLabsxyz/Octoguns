#!/usr/bin/env bash
set -euo pipefail
pushd $(dirname "$0")/..


export WORLD_ADDRESS=$(cat ./manifest_sepolia.json | jq -r '.world.address')

# sozo execute --world <WORLD_ADDRESS> <CONTRACT> <ENTRYPOINT>
sozo -P sepolia execute mapmaker default_map --world $WORLD_ADDRESS --keystore '../sepolia_key' --fee eth --wait
sozo -P sepolia execute planetelo-planetelo spawn_default_playlist --world $WORLD_ADDRESS --fee eth --keystore '../sepolia_key'
